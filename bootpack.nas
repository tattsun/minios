[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_sprintf
	EXTERN	_io_hlt
	EXTERN	_io_load_eflags
	EXTERN	_io_cli
	EXTERN	_io_out8
	EXTERN	_io_store_eflags
	EXTERN	_hankaku
	EXTERN	_load_gdtr
	EXTERN	_load_idtr
[FILE "bootpack.c"]
[SECTION .data]
LC0:
	DB	"scrnx = %d",0x00
[SECTION .text]
	GLOBAL	_HariMain
_HariMain:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	ESI
	PUSH	EBX
	SUB	ESP,304
	LEA	ESI,DWORD [-312+EBP]
	LEA	EBX,DWORD [-56+EBP]
	CALL	_init_gdtidt
	CALL	_init_palette
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_init_screen
	PUSH	14
	PUSH	ESI
	CALL	_init_mouse_cursor8
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	LC0
	PUSH	EBX
	CALL	_sprintf
	ADD	ESP,32
	PUSH	EBX
	PUSH	7
	PUSH	8
	PUSH	8
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfont8_asc
	PUSH	16
	PUSH	ESI
	PUSH	20
	PUSH	20
	PUSH	16
	PUSH	16
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putblock8_8
	ADD	ESP,56
L5:
	CALL	_io_hlt
	JMP	L5
	GLOBAL	_init_screen
_init_screen:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	SUB	ESP,12
	MOV	EAX,DWORD [16+EBP]
	MOV	EDI,DWORD [12+EBP]
	SUB	EAX,29
	DEC	EDI
	PUSH	EAX
	PUSH	EDI
	PUSH	0
	PUSH	0
	PUSH	14
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [16+EBP]
	SUB	EAX,28
	PUSH	EAX
	PUSH	EDI
	PUSH	EAX
	PUSH	0
	PUSH	8
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [16+EBP]
	ADD	ESP,56
	SUB	EAX,27
	PUSH	EAX
	PUSH	EDI
	PUSH	EAX
	PUSH	0
	PUSH	7
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [16+EBP]
	DEC	EAX
	PUSH	EAX
	MOV	EAX,DWORD [16+EBP]
	PUSH	EDI
	SUB	EAX,26
	PUSH	EAX
	PUSH	0
	PUSH	8
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	ESI,DWORD [16+EBP]
	ADD	ESP,56
	SUB	ESI,24
	PUSH	ESI
	PUSH	59
	PUSH	ESI
	PUSH	3
	PUSH	7
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [16+EBP]
	SUB	EAX,4
	PUSH	EAX
	MOV	DWORD [-16+EBP],EAX
	PUSH	2
	PUSH	ESI
	PUSH	2
	PUSH	7
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	ADD	ESP,56
	PUSH	DWORD [-16+EBP]
	PUSH	59
	PUSH	DWORD [-16+EBP]
	PUSH	3
	PUSH	15
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [16+EBP]
	SUB	EAX,5
	PUSH	EAX
	MOV	EAX,DWORD [16+EBP]
	PUSH	59
	SUB	EAX,23
	PUSH	EAX
	MOV	DWORD [-20+EBP],EAX
	PUSH	59
	PUSH	15
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [16+EBP]
	ADD	ESP,56
	SUB	EAX,3
	MOV	DWORD [-24+EBP],EAX
	PUSH	EAX
	PUSH	59
	PUSH	EAX
	PUSH	2
	PUSH	0
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	PUSH	DWORD [-24+EBP]
	PUSH	60
	PUSH	ESI
	PUSH	60
	PUSH	0
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EDI,DWORD [12+EBP]
	ADD	ESP,56
	MOV	EBX,DWORD [12+EBP]
	SUB	EBX,4
	SUB	EDI,47
	PUSH	ESI
	PUSH	EBX
	PUSH	ESI
	PUSH	EDI
	PUSH	15
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	PUSH	DWORD [-16+EBP]
	PUSH	EDI
	PUSH	DWORD [-20+EBP]
	PUSH	EDI
	PUSH	15
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	ADD	ESP,56
	PUSH	DWORD [-24+EBP]
	PUSH	EBX
	PUSH	DWORD [-24+EBP]
	PUSH	EDI
	PUSH	7
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [12+EBP]
	PUSH	DWORD [-24+EBP]
	SUB	EAX,3
	PUSH	EAX
	PUSH	ESI
	PUSH	EAX
	PUSH	7
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	GLOBAL	_boxfill8
_boxfill8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	ECX
	PUSH	ECX
	MOV	AL,BYTE [16+EBP]
	MOV	ECX,DWORD [24+EBP]
	MOV	EDI,DWORD [28+EBP]
	MOV	BYTE [-13+EBP],AL
	CMP	ECX,DWORD [32+EBP]
	JG	L19
	MOV	EBX,DWORD [12+EBP]
	IMUL	EBX,ECX
L17:
	MOV	EDX,DWORD [20+EBP]
	CMP	EDX,EDI
	JG	L21
	MOV	ESI,DWORD [8+EBP]
	ADD	ESI,EBX
	ADD	ESI,EDX
	MOV	DWORD [-20+EBP],ESI
L16:
	MOV	ESI,DWORD [-20+EBP]
	MOV	AL,BYTE [-13+EBP]
	INC	EDX
	MOV	BYTE [ESI],AL
	INC	ESI
	MOV	DWORD [-20+EBP],ESI
	CMP	EDX,EDI
	JLE	L16
L21:
	INC	ECX
	ADD	EBX,DWORD [12+EBP]
	CMP	ECX,DWORD [32+EBP]
	JLE	L17
L19:
	POP	EAX
	POP	EDX
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
[SECTION .data]
_rgb.0:
	DB	0
	DB	0
	DB	0
	DB	-1
	DB	0
	DB	0
	DB	0
	DB	-1
	DB	0
	DB	-1
	DB	-1
	DB	0
	DB	0
	DB	0
	DB	-1
	DB	-1
	DB	0
	DB	-1
	DB	0
	DB	-1
	DB	-1
	DB	-1
	DB	-1
	DB	-1
	DB	-58
	DB	-58
	DB	-58
	DB	-124
	DB	0
	DB	0
	DB	0
	DB	-124
	DB	0
	DB	-124
	DB	-124
	DB	0
	DB	0
	DB	0
	DB	-124
	DB	-124
	DB	0
	DB	-124
	DB	0
	DB	-124
	DB	-124
	DB	-124
	DB	-124
	DB	-124
[SECTION .text]
	GLOBAL	_init_palette
_init_palette:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	_rgb.0
	PUSH	16
	CALL	_set_palette
	LEAVE
	RET
	GLOBAL	_set_palette
_set_palette:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	MOV	EBX,DWORD [8+EBP]
	MOV	ESI,DWORD [12+EBP]
	CALL	_io_load_eflags
	MOV	EDI,EAX
	CALL	_io_cli
	PUSH	0
	PUSH	968
	CALL	_io_out8
	TEST	EBX,EBX
	POP	EAX
	POP	EDX
	JLE	L30
L28:
	MOV	AL,BYTE [ESI]
	SHR	AL,2
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_io_out8
	MOV	AL,BYTE [1+ESI]
	SHR	AL,2
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_io_out8
	MOV	AL,BYTE [2+ESI]
	SHR	AL,2
	ADD	ESI,3
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_io_out8
	ADD	ESP,24
	DEC	EBX
	JNE	L28
L30:
	MOV	DWORD [8+EBP],EDI
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	JMP	_io_store_eflags
	GLOBAL	_putfont8
_putfont8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	EBX
	XOR	EBX,EBX
	MOV	EDI,DWORD [20+EBP]
	MOV	ESI,DWORD [28+EBP]
	MOV	CL,BYTE [24+EBP]
L44:
	LEA	EAX,DWORD [EBX+EDI*1]
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,DWORD [8+EBP]
	MOV	EDX,EAX
	ADD	EDX,DWORD [16+EBP]
	CMP	BYTE [EBX+ESI*1],0
	JNS	L36
	MOV	BYTE [EDX],CL
L36:
	MOV	AL,BYTE [EBX+ESI*1]
	AND	EAX,64
	TEST	AL,AL
	JE	L37
	MOV	BYTE [1+EDX],CL
L37:
	MOV	AL,BYTE [EBX+ESI*1]
	AND	EAX,32
	TEST	AL,AL
	JE	L38
	MOV	BYTE [2+EDX],CL
L38:
	MOV	AL,BYTE [EBX+ESI*1]
	AND	EAX,16
	TEST	AL,AL
	JE	L39
	MOV	BYTE [3+EDX],CL
L39:
	MOV	AL,BYTE [EBX+ESI*1]
	AND	EAX,8
	TEST	AL,AL
	JE	L40
	MOV	BYTE [4+EDX],CL
L40:
	MOV	AL,BYTE [EBX+ESI*1]
	AND	EAX,4
	TEST	AL,AL
	JE	L41
	MOV	BYTE [5+EDX],CL
L41:
	MOV	AL,BYTE [EBX+ESI*1]
	AND	EAX,2
	TEST	AL,AL
	JE	L42
	MOV	BYTE [6+EDX],CL
L42:
	MOV	AL,BYTE [EBX+ESI*1]
	AND	EAX,1
	TEST	AL,AL
	JE	L34
	MOV	BYTE [7+EDX],CL
L34:
	INC	EBX
	CMP	EBX,15
	JLE	L44
	POP	ECX
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	GLOBAL	_putfont8_asc
_putfont8_asc:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	ESI
	XOR	ESI,ESI
	MOV	EBX,DWORD [28+EBP]
	MOV	AL,BYTE [24+EBP]
	MOV	BYTE [-13+EBP],AL
	MOV	EDI,DWORD [20+EBP]
	CMP	BYTE [EBX],0
	JNE	L52
L54:
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
L52:
	MOVSX	EAX,BYTE [EBX]
	SAL	EAX,4
	INC	EBX
	ADD	EAX,_hankaku
	PUSH	EAX
	MOVSX	EAX,BYTE [-13+EBP]
	PUSH	EAX
	MOV	EAX,DWORD [16+EBP]
	PUSH	EDI
	ADD	EAX,ESI
	PUSH	EAX
	ADD	ESI,8
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_putfont8
	ADD	ESP,24
	CMP	BYTE [EBX],0
	JNE	L52
	JMP	L54
[SECTION .data]
_cursor.1:
	DB	"**************.."
	DB	"*OOOOOOOOOOO*..."
	DB	"*OOOOOOOOOO*...."
	DB	"*OOOOOOOOO*....."
	DB	"*OOOOOOOO*......"
	DB	"*OOOOOOO*......."
	DB	"*OOOOOOO*......."
	DB	"*OOOOOOOO*......"
	DB	"*OOOO**OOO*....."
	DB	"*OOO*..*OOO*...."
	DB	"*OO*....*OOO*..."
	DB	"*O*......*OOO*.."
	DB	"**........*OOO*."
	DB	"*..........*OOO*"
	DB	"............*OO*"
	DB	".............***"
[SECTION .text]
	GLOBAL	_init_mouse_cursor8
_init_mouse_cursor8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	XOR	ESI,ESI
	PUSH	EBX
	XOR	EBX,EBX
	PUSH	EAX
	MOV	AL,BYTE [12+EBP]
	MOV	EDI,DWORD [8+EBP]
	MOV	BYTE [-13+EBP],AL
L70:
	XOR	ECX,ECX
L69:
	LEA	EDX,DWORD [ECX+EBX*1]
	MOV	AL,BYTE [_cursor.1+EDX]
	CMP	AL,42
	JE	L75
	CMP	AL,79
	JE	L76
	CMP	AL,46
	JE	L77
L62:
	INC	ECX
	CMP	ECX,15
	JLE	L69
	INC	ESI
	ADD	EBX,16
	CMP	ESI,15
	JLE	L70
	POP	EDI
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
L77:
	MOV	AL,BYTE [-13+EBP]
	MOV	BYTE [EDX+EDI*1],AL
	JMP	L62
L76:
	MOV	BYTE [EDX+EDI*1],7
	JMP	L62
L75:
	MOV	BYTE [EDX+EDI*1],0
	JMP	L62
	GLOBAL	_putblock8_8
_putblock8_8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	XOR	ESI,ESI
	PUSH	EBX
	SUB	ESP,12
	CMP	ESI,DWORD [20+EBP]
	JGE	L90
	XOR	EDI,EDI
L88:
	XOR	EBX,EBX
	CMP	EBX,DWORD [16+EBP]
	JGE	L92
	MOV	EAX,DWORD [32+EBP]
	ADD	EAX,EDI
	MOV	DWORD [-20+EBP],EAX
L87:
	MOV	EAX,DWORD [28+EBP]
	MOV	EDX,DWORD [24+EBP]
	ADD	EAX,ESI
	ADD	EDX,EBX
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,EDX
	MOV	ECX,DWORD [8+EBP]
	MOV	EDX,DWORD [-20+EBP]
	INC	EBX
	MOV	DL,BYTE [EDX]
	MOV	BYTE [EAX+ECX*1],DL
	INC	DWORD [-20+EBP]
	CMP	EBX,DWORD [16+EBP]
	JL	L87
L92:
	INC	ESI
	ADD	EDI,DWORD [36+EBP]
	CMP	ESI,DWORD [20+EBP]
	JL	L88
L90:
	ADD	ESP,12
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	GLOBAL	_init_gdtidt
_init_gdtidt:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	ESI
	PUSH	EBX
	MOV	ESI,2555904
	MOV	EBX,8191
L98:
	PUSH	0
	PUSH	0
	PUSH	0
	PUSH	ESI
	ADD	ESI,8
	CALL	_set_segmdesc
	ADD	ESP,16
	DEC	EBX
	JNS	L98
	PUSH	16530
	MOV	ESI,2553856
	PUSH	0
	MOV	EBX,255
	PUSH	-1
	PUSH	2555912
	CALL	_set_segmdesc
	PUSH	16538
	PUSH	2621440
	PUSH	524287
	PUSH	2555920
	CALL	_set_segmdesc
	ADD	ESP,32
	PUSH	2555904
	PUSH	65535
	CALL	_load_gdtr
	POP	EAX
	POP	EDX
L103:
	PUSH	0
	PUSH	0
	PUSH	0
	PUSH	ESI
	ADD	ESI,8
	CALL	_set_gatedesc
	ADD	ESP,16
	DEC	EBX
	JNS	L103
	PUSH	2553856
	PUSH	2047
	CALL	_load_idtr
	LEA	ESP,DWORD [-8+EBP]
	POP	EBX
	POP	ESI
	POP	EBP
	RET
	GLOBAL	_set_segmdesc
_set_segmdesc:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EBX
	MOV	EDX,DWORD [12+EBP]
	MOV	ECX,DWORD [16+EBP]
	MOV	EBX,DWORD [8+EBP]
	MOV	EAX,DWORD [20+EBP]
	CMP	EDX,65535
	JBE	L109
	SHR	EDX,12
	OR	EAX,32768
L109:
	MOV	WORD [EBX],DX
	MOV	BYTE [5+EBX],AL
	SHR	EDX,16
	SAR	EAX,8
	AND	EDX,15
	MOV	WORD [2+EBX],CX
	AND	EAX,-16
	SAR	ECX,16
	OR	EDX,EAX
	MOV	BYTE [4+EBX],CL
	MOV	BYTE [6+EBX],DL
	SAR	ECX,8
	MOV	BYTE [7+EBX],CL
	POP	EBX
	POP	EBP
	RET
	GLOBAL	_set_gatedesc
_set_gatedesc:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EBX
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [16+EBP]
	MOV	EBX,DWORD [20+EBP]
	MOV	ECX,DWORD [12+EBP]
	MOV	WORD [2+EDX],AX
	MOV	BYTE [5+EDX],BL
	MOV	WORD [EDX],CX
	MOV	EAX,EBX
	SAR	EAX,8
	SAR	ECX,16
	MOV	BYTE [4+EDX],AL
	MOV	WORD [6+EDX],CX
	POP	EBX
	POP	EBP
	RET
