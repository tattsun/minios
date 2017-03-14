  BOTPAK  EQU 0x00280000        ; bootpackのロード先
  DSKCAC  EQU 0x00100000        ; ディスクキャッシュの場所
  DSKCAC0 EQU 0x00008000        ; ディスクキャッシュの場所（リアルモード）

;;  BOOT INFO関連
  CYLS  EQU 0x0ff0
  LEDS  EQU 0x0ff1
  VMODE EQU 0x0ff2              ; 何ビットカラーか
  SCRNX EQU 0x0ff4              ; 解像度X
  SCRNY EQU 0x0ff6              ; 解像度Y
  VRAM  EQU 0x0ff8              ; グラフィックバッファの開始番地

  ORG 0xc200                    ; このプログラムが読み込まれるポイント

  ;; ビデオモード設定
  MOV AL, 0x13                  ; VGA 320x200x8bit
  MOV AH, 0x00
  INT 0x10
  ;; 各種変数を記録
  MOV BYTE [VMODE], 8
  MOV WORD [SCRNX], 320
  MOV WORD [SCRNY], 200
  MOV DWORD [VRAM], 0x000a0000  ; 0xa0000 ~ 0xaffff の64KBになっている

  ;; キーボードのLED状態をBIOSに教えてもらう
  MOV AH, 0x02
  INT 0x16                      ; keyboard BIOS
  MOV [LEDS], AL

  ;;  PICが一切の割り込みを受け付けないようにする
  MOV AL, 0xff
  OUT 0x21, AL
  NOP
  OUT 0xa1, AL
  CLI

  ;;  CPUから1mb以上のメモリにアクセスできるように、A20GATEを設定
  CALL waitkbdout
  MOV AL, 0xd1
  OUT 0x64, AL
  CALL waitkbdout
  MOV AL, 0xdf
  OUT 0x60, AL
  CALL waitkbdout

  ;; プロテクトモード移行
[INSTRSET "i486p"]
  LGDT [GDTR0]
  MOV EAX, CR0
  AND EAX, 0x7fffffff
  OR  EAX, 0x00000001
  MOV CR0, EAX
  JMP pipelineflush
pipelineflush:
  MOV AX, 1*8
  MOV DS, AX
  MOV ES, AX
  MOV FS, AX
  MOV GS, AX
  MOV SS, AX

  ;; bootpackの転送
  MOV ESI, bootpack
  MOV EDI, BOTPAK
  MOV ECX, 512*1024/4
  CALL memcpy

  ;; ディスクデータも本来の位置に転送
  ;; ブートセクタ
  MOV ESI, 0x7c00
  MOV EDI, DSKCAC
  MOV ECX, 512/4
  CALL memcpy
  ;; 残り
  MOV ESI, DSKCAC0+512
  MOV EDI, DSKCAC+512
  MOV ECX, 0
  MOV CL, BYTE [CYLS]
  IMUL ECX, 512*18*2/4
  SUB ECX, 512/4
  CALL memcpy

  ;; bootpackの起動
  MOV EBX, BOTPAK
  MOV ECX, [EBX+16]
  ADD ECX, 3
  SHR ECX, 2
  JZ  skip
  MOV ESI, [EBX+20]
  ADD ESI, EBX
  MOV EDI, [EBX+12]
  CALL memcpy
skip:
  MOV ESP, [EBX+12]
  JMP DWORD 2*8:0x0000001b

waitkbdout:
  IN  AL, 0x64
  AND AL, 0x02
  JNZ waitkbdout
  RET

memcpy:
  MOV EAX, [ESI]
  ADD ESI, 4
  MOV [EDI], EAX
  ADD EDI, 4
  SUB ECX, 1
  JNZ memcpy
  RET

  ALIGNB 16

GDT0:
  RESB 8
  DW  0xffff, 0x0000, 0x9200, 0x00cf
  DW  0xffff, 0x0000, 0x9a28, 0x0047
  DW  0
GDTR0:
  DW  8*3-1
  DD  GDT0

  ALIGNB 16

bootpack:
