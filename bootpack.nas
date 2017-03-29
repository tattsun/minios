[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_init_gdtidt
	EXTERN	_init_pic
	EXTERN	_io_sti
	EXTERN	_io_out8
	EXTERN	_init_palette
	EXTERN	_init_screen
	EXTERN	_init_mouse_cursor8
	EXTERN	_putblock8_8
	EXTERN	_sprintf
	EXTERN	_putfont8_asc
	EXTERN	_init_keybuf
	EXTERN	_init_mousebuf
	EXTERN	_io_cli
	EXTERN	_keybuf
	EXTERN	_queue8_size
	EXTERN	_mousebuf
	EXTERN	_queue8_pop
	EXTERN	_boxfill8
	EXTERN	_io_stihlt
	EXTERN	_io_in8
[FILE "bootpack.c"]
[SECTION .data]
LC0:
	DB	"(%d, %d)",0x00
LC2:
	DB	"M %02X",0x00
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
	LEA	EBX,DWORD [-316+EBP]
	SUB	ESP,304
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
	MOV	ECX,2
	MOVSX	EAX,WORD [4084]
	LEA	EDX,DWORD [-16+EAX]
	MOV	EAX,EDX
	CDQ
	IDIV	ECX
	MOVSX	EDX,WORD [4086]
	SUB	EDX,44
	MOV	EDI,EAX
	MOV	EAX,EDX
	PUSH	14
	CDQ
	IDIV	ECX
	PUSH	EBX
	MOV	ESI,EAX
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
	CALL	_enable_mouse
L10:
	CALL	_io_cli
	PUSH	_keybuf
	CALL	_queue8_size
	PUSH	_mousebuf
	MOV	EBX,EAX
	CALL	_queue8_size
	LEA	EAX,DWORD [EAX+EBX*1]
	POP	EBX
	POP	ESI
	TEST	EAX,EAX
	JE	L12
	PUSH	_keybuf
	CALL	_queue8_size
	POP	ECX
	TEST	EAX,EAX
	JNE	L13
	PUSH	_mousebuf
	CALL	_queue8_size
	POP	EDX
	TEST	EAX,EAX
	JE	L10
	PUSH	_mousebuf
	CALL	_queue8_pop
	MOVZX	EBX,AL
	CALL	_io_sti
	PUSH	EBX
	PUSH	LC2
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
L11:
	PUSH	EBX
	PUSH	7
	PUSH	0
	PUSH	0
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfont8_asc
	ADD	ESP,24
	JMP	L10
L13:
	PUSH	_keybuf
	CALL	_queue8_pop
	MOVZX	EBX,AL
	CALL	_io_sti
	PUSH	_keybuf
	CALL	_queue8_size
	MOV	DWORD [ESP],EAX
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
	ADD	ESP,48
	JMP	L11
L12:
	CALL	_io_stihlt
	JMP	L10
	GLOBAL	_wait_KBC_sendready
_wait_KBC_sendready:
	PUSH	EBP
	MOV	EBP,ESP
L15:
	PUSH	100
	CALL	_io_in8
	POP	EDX
	AND	EAX,2
	JNE	L15
	LEAVE
	RET
	GLOBAL	_init_keyboard
_init_keyboard:
	PUSH	EBP
	MOV	EBP,ESP
	CALL	_wait_KBC_sendready
	PUSH	96
	PUSH	100
	CALL	_io_out8
	CALL	_wait_KBC_sendready
	PUSH	71
	PUSH	96
	CALL	_io_out8
	LEAVE
	RET
	GLOBAL	_enable_mouse
_enable_mouse:
	PUSH	EBP
	MOV	EBP,ESP
	CALL	_wait_KBC_sendready
	PUSH	212
	PUSH	100
	CALL	_io_out8
	CALL	_wait_KBC_sendready
	PUSH	244
	PUSH	96
	CALL	_io_out8
	LEAVE
	RET
