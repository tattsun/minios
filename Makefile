INCPATH = tools/haribote/

MAKE			= make -r
NASK			= tools/nask
EDIMG			= tools/edimg
CC1				= tools/gocc1 -I$(INCPATH) -Os -Wall -quiet
GAS2NASK	= tools/gas2nask -a
OBJ2BIM		= tools/obj2bim
BIN2OBJ		= tools/bin2obj
BIM2HRB		= tools/bim2hrb
RULEFILE	= tools/haribote/haribote.rul
IMGTOL		= tools/imgtol
MAKEFONT  = tools/makefont
COPY			= cp
DEL				= rm -f

# デフォルト動作
default:
	$(MAKE) img

# ファイル生成規則

ipl10.bin: ipl10.nas Makefile
	$(NASK) ipl10.nas ipl10.bin ipl10.lst

asmhead.bin: asmhead.nas Makefile
	$(NASK) asmhead.nas asmhead.bin asmhead.lst

hankaku.bin: hankaku.txt Makefile
	$(MAKEFONT) hankaku.txt hankaku.bin

hankaku.obj: hankaku.bin Makefile
	$(BIN2OBJ) hankaku.bin hankaku.obj _hankaku

bootpack.bim: bootpack.obj naskfunc.obj hankaku.obj graphic.obj dsctbl.obj int.obj queue.obj Makefile
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
		bootpack.obj naskfunc.obj hankaku.obj graphic.obj dsctbl.obj int.obj queue.obj

bootpack.hrb: bootpack.bim Makefile
	$(BIM2HRB) bootpack.bim bootpack.hrb 0

minios.sys: asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > minios.sys

helloos.img: ipl10.bin minios.sys Makefile
	$(EDIMG) imgin:./tools/fdimg0at.tek \
		wbinimg src:ipl10.bin len:512 from:0 to:0 \
		copy from:minios.sys to:@: \
		imgout:helloos.img

# 一般規則

%.gas: %.c Makefile
	$(CC1) -o $*.gas $*.c

%.nas: %.gas Makefile
	$(GAS2NASK) $*.gas $*.nas

%.obj: %.nas Makefile
	$(NASK) $*.nas $*.obj $*.lst

# コマンド
img:
	$(MAKE) helloos.img

run:
	$(MAKE) img
	qemu-system-x86_64 -L . -m 32 -localtime -vga std -fda ./helloos.img
