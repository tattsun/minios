[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_init_gdtidt
	EXTERN	_init_pic
	EXTERN	_io_sti
	EXTERN	_io_out8
	EXTERN	_init_keyboard
	EXTERN	_init_palette
	EXTERN	_init_screen
	EXTERN	_init_mouse_cursor8
	EXTERN	_putblock8_8
	EXTERN	_sprintf
	EXTERN	_putfont8_asc
	EXTERN	_init_keybuf
	EXTERN	_init_mousebuf
	EXTERN	_init_mousestate
	EXTERN	_enable_mouse
	EXTERN	_io_cli
	EXTERN	_keybuf
	EXTERN	_queue8_size
	EXTERN	_mousebuf
	EXTERN	_queue8_pop
	EXTERN	_decode_mousestate
	EXTERN	_boxfill8
	EXTERN	_io_stihlt
[FILE "bootpack.c"]
[SECTION .data]
LC0:
	DB	"(%d, %d)",0x00
LC2:
	DB	"%d %d",0x00
LC1:
	DB	"K %02X",0x00
[SECTION .text]
	GLOBAL	_HariMain
_HariMain:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	MOV	EBX,2
	SUB	ESP,340
	CALL	_init_gdtidt
	CALL	_init_pic
	CALL	_io_sti
	PUSH	249
	PUSH	33
	CALL	_io_out8
	PUSH	239
	PUSH	161
	CALL	_io_out8
	CALL	_init_keyboard
	CALL	_init_palette
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_init_screen
	MOVSX	EAX,WORD [4084]
	LEA	ECX,DWORD [-16+EAX]
	MOV	EAX,ECX
	CDQ
	IDIV	EBX
	MOV	EDI,EAX
	MOVSX	EAX,WORD [4086]
	PUSH	14
	LEA	ECX,DWORD [-44+EAX]
	MOV	EAX,ECX
	CDQ
	IDIV	EBX
	LEA	EBX,DWORD [-316+EBP]
	MOV	ESI,EAX
	PUSH	EBX
	CALL	_init_mouse_cursor8
	ADD	ESP,36
	PUSH	16
	PUSH	EBX
	LEA	EBX,DWORD [-60+EBP]
	PUSH	ESI
	PUSH	EDI
	PUSH	16
	PUSH	16
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putblock8_8
	ADD	ESP,32
	PUSH	ESI
	PUSH	EDI
	PUSH	LC0
	PUSH	EBX
	CALL	_sprintf
	PUSH	EBX
	PUSH	7
	PUSH	8
	PUSH	8
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfont8_asc
	ADD	ESP,40
	CALL	_init_keybuf
	CALL	_init_mousebuf
	LEA	EAX,DWORD [-348+EBP]
	PUSH	EAX
	CALL	_init_mousestate
	CALL	_enable_mouse
	POP	ECX
L15:
	CALL	_io_cli
	PUSH	_keybuf
	CALL	_queue8_size
	PUSH	_mousebuf
	MOV	EBX,EAX
	CALL	_queue8_size
	LEA	EAX,DWORD [EAX+EBX*1]
	POP	EBX
	POP	EDX
	TEST	EAX,EAX
	JE	L16
	PUSH	_keybuf
	CALL	_queue8_size
	POP	ECX
	TEST	EAX,EAX
	JNE	L17
	PUSH	_mousebuf
	CALL	_queue8_size
	POP	EDX
	TEST	EAX,EAX
	JE	L15
	PUSH	_mousebuf
	CALL	_queue8_pop
	MOVZX	EBX,AL
	CALL	_io_sti
	LEA	EAX,DWORD [-348+EBP]
	PUSH	EBX
	PUSH	EAX
	CALL	_decode_mousestate
	ADD	ESP,12
	TEST	EAX,EAX
	JE	L15
	PUSH	DWORD [-344+EBP]
	PUSH	DWORD [-348+EBP]
	PUSH	LC2
	LEA	EBX,DWORD [-60+EBP]
	PUSH	EBX
	CALL	_sprintf
	PUSH	41
	PUSH	100
	PUSH	25
	PUSH	0
	PUSH	14
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_boxfill8
	ADD	ESP,44
	PUSH	EBX
	PUSH	7
	PUSH	25
	PUSH	0
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfont8_asc
	LEA	EAX,DWORD [16+ESI]
	PUSH	EAX
	LEA	EAX,DWORD [16+EDI]
	PUSH	EAX
	PUSH	ESI
	PUSH	EDI
	PUSH	14
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_boxfill8
	ADD	ESP,52
	ADD	ESI,DWORD [-344+EBP]
	ADD	EDI,DWORD [-348+EBP]
	JS	L18
L11:
	TEST	ESI,ESI
	JS	L19
L12:
	MOVSX	EAX,WORD [4084]
	SUB	EAX,16
	CMP	EDI,EAX
	JLE	L13
	MOV	EDI,EAX
L13:
	MOVSX	EAX,WORD [4086]
	SUB	EAX,16
	CMP	ESI,EAX
	JLE	L14
	MOV	ESI,EAX
L14:
	PUSH	16
	LEA	EAX,DWORD [-316+EBP]
	PUSH	EAX
	PUSH	ESI
	PUSH	EDI
	PUSH	16
	PUSH	16
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putblock8_8
	ADD	ESP,32
	JMP	L15
L19:
	XOR	ESI,ESI
	JMP	L12
L18:
	XOR	EDI,EDI
	JMP	L11
L17:
	PUSH	_keybuf
	CALL	_queue8_pop
	MOVZX	EBX,AL
	CALL	_io_sti
	PUSH	EBX
	PUSH	LC1
	LEA	EBX,DWORD [-60+EBP]
	PUSH	EBX
	CALL	_sprintf
	PUSH	30
	PUSH	60
	PUSH	0
	PUSH	0
	PUSH	14
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_boxfill8
	ADD	ESP,44
	PUSH	EBX
	PUSH	7
	PUSH	0
	PUSH	0
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfont8_asc
	ADD	ESP,24
	JMP	L15
L16:
	CALL	_io_stihlt
	JMP	L15
