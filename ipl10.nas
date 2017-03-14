CYLS EQU 10                     ; どこまで読み込むか（シリンダ）

  ORG 0x7c00                      ; プログラムの読み込み場所

; FAT12フォーマットフロッピーディスクのための記述
  JMP entry
	DB 0x90
	DB "MINIOS  "  ; ブートセクタ名( 8 bytes )
	DW 512         ; 1セクタの大きさ
	DB 1           ; クラスタの大きさ
	DW 1           ; FATがどこから始まるか
	DB 2           ; FATの個数
	DW 224         ; ルートディレクトリ領域の大きさ
	DW 2880        ; このドライブの大きさ（セクタ数）
	DB 0xf0        ; メディアのタイプ
	DW 9           ; FAT領域の長さ
	DW 18          ; トラックにいくつのセクタがあるか
	DW 2           ; ヘッドの数
	DD 0           ; ＝パーティションを使っていない
	DD 2880        ; このドライブの大きさ
	DB 0, 0, 0x29  ; ？
  DD 0xffffffff  ; ボリュームシリアル番号
  DB "MINIOS     " ; ディスク名( 11 bytes )
  DB "FAT12   "  ; フォーマット名( 8 bytes )
  RESB 18

; プログラム本体
entry:
  MOV AX, 0                     ; レジスタ初期化
  MOV SS, AX
  MOV SP, 0x7c00
  MOV DS, AX

                                ; ディスクを読む
  MOV AX, 0x0820                ; ブートセクタは0x20 bytesなので、その後の0x820にプログラム本体を読む
  MOV ES, AX
  MOV CH, 0                     ; シリンダ0
  MOV DH, 0                     ; ヘッド0
  MOV CL, 2                     ; セクタ2

readloop:
  MOV SI, 0                     ; 失敗回数=0
retry:
  MOV AH, 0x02                  ; AH=0x02 : ディスク読み込み
  MOV AL, 1                     ; 1セクタ読む
  MOV BX, 0
  MOV DL, 0x00                  ; Aドライブ
  INT 0x13                      ; Disk BIOS 呼び出し
  JNC next
  ADD SI, 1                     ; 失敗回数++
  CMP SI, 5                     ; 失敗回数と5を比較
  JAE error                     ; SI >= 5のときerrorへ
  MOV AH, 0x00
  MOV DL, 0x00
  INT 0x13                      ; ドライブリセット
  JMP retry
next:
  MOV AX, ES                    ; アドレスを0x020すすめる
  ADD AX, 0x0020
  MOV ES, AX                    ; ADD ES, 0x020という命令はない！
  ADD CL, 1                     ; セクタ++
  CMP CL, 18
  JBE readloop                  ; セクタ <= 18のときreadloop
  MOV CL, 1
  ADD DH, 1
  CMP DH, 2
  JB  readloop                   ; ヘッド < 2のときreadloop
  MOV DH, 0
  ADD CH, 1
  CMP CH, CYLS
  JB  readloop                  ; CH < CYLSで

  MOV [0x0ff0], CH               ; IPLがどこまで読んだのかをメモ
  JMP 0xc200                    ; 読み終わったので本体プログラムへ

error:
  MOV SI, msg

putloop:
  MOV AL, [SI]
  ADD SI, 1                     ; SIに1を足す
  CMP AL, 0
  JE  fin
  MOV AH, 0x0e                  ; 一文字表示ファンクション
  MOV BX, 15                    ; カラーコード
  INT 0x10                      ; ビデオBIOS呼び出し
  JMP putloop
fin:
  HLT
  JMP fin
msg:
  DB 0x0a, 0x0a ; 改行
  DB "load error"
  DB 0x0a    ; 改行
  DB 0

  RESB 0x7dfe-$ ; 0x7dfeまでを0x00で埋める

  DB 0x55, 0xaa
