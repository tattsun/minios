INCPATH = tools/haribote/

NASK			= tools/nask
EDIMG			= tools/edimg
CC1				= tools/gocc1 -I$(INCPATH) -Os -Wall -quiet
GAS2NASK	= tools/gas2nask -a
OBJ2BIM		= tools/obj2bim
BIM2HRB		= tools/bim2hrb
RULEFILE	= tools/haribote/haribote.rul
IMGTOL		= tools/imgtol
COPY			= cp
DEL				= rm -f

ipl10.bin: ipl10.nas Makefile
	$(NASK) ipl10.nas ipl10.bin ipl10.lst

asmhead.bin: asmhead.nas Makefile
	$(NASK) asmhead.nas asmhead.bin asmhead.lst

bootpack.gas: bootpack.c Makefile
	$(CC1) -o bootpack.gas bootpack.c

bootpack.nas: bootpack.gas Makefile
	$(GAS2NASK) bootpack.gas bootpack.nas

bootpack.obj: bootpack.nas Makefile
	$(NASK) bootpack.nas bootpack.obj bootpack.lst

naskfunc.obj: naskfunc.nas Makefile
	$(NASK) naskfunc.nas naskfunc.obj naskfunc.lst

bootpack.bim: bootpack.obj naskfunc.obj Makefile
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
		bootpack.obj naskfunc.obj

bootpack.hrb: bootpack.bim Makefile
	$(BIM2HRB) bootpack.bim bootpack.hrb 0

minios.sys: asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > minios.sys

helloos.img: ipl10.bin minios.sys Makefile
	$(EDIMG) imgin:./tools/fdimg0at.tek \
		wbinimg src:ipl10.bin len:512 from:0 to:0 \
		copy from:minios.sys to:@: \
		imgout:helloos.img

run: helloos.img
	qemu-system-x86_64 -L . -m 32 -localtime -vga std -fda ./helloos.img
