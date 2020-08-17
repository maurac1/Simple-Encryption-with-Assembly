; Maura Choudhary
; Project 4
; validate.asm

	section .data
punc1:		db	"."
punc2:		db	"?"
punc3:		db	"!"

cap1:		db	"A"
cap2:		db	"Z"

msg:		db	"Here"
len		equ	$-msg
	
	section .bss
data:		resb	1
char1:		resb	1
char2:		resb	1
	
	section	.text
	global validate

validate:

	mov	rcx, rsi
	mov	rdx, rdi

	;store parameters
	mov	[char1], cl
	mov	[char2], dl

	mov	al, [char1]

	;compare to .
	mov	ah, [punc1]
	cmp	al, ah
	je	check_front

	;compare to ?
	mov	ah, [punc2]
	cmp	al, ah
	je	check_front
	
	;compare to !
	mov	ah, [punc3]
	cmp	al, ah
	je	check_front
	
	jmp	invalid
	
check_front:
	
	mov	al, [char2]
	
	;compare to capital A
	mov	ah, [cap1]
	cmp	al, ah
	jl	invalid

	;compare to capital Z
	mov	ah, [cap2]
	cmp	al, ah
	jg	invalid
	jmp	valid

valid:
	mov	rax, 1
	ret

invalid:
	mov	rax, 0
	ret

		
