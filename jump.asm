; Maura Choudhary
; Project 4
; jump.asm

	section .data
prompt:		db	"Jump encryption: "
len_prompt:	equ	$-prompt

new_line:	db	10

	section	.bss
char_buff	resb	1

	section .text
	global jump

jump:
	push	rbp
	;store jump value in
	
	;print prompt
	push	rdi
	push	rsi
	push	rdx
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, prompt
	mov	rdx, len_prompt
	syscall
	pop	rdx
	pop	rsi
	pop	rdi

	;initialize outer count
	mov	r11, 0

outer_loop:
	
	;initialize inner count
	mov	r10, r11	
	
	;initialize inner address
	mov	rcx, rdx

inner_loop:
	;get the current character
	mov	al, [rcx]
	mov	[char_buff], al
	
	;print the current character
	push	rdi
	push	rsi
	push	rdx
	push	rcx
	push	r10
	push	r11
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, char_buff
	mov	rdx, 1
	syscall
	pop	r11
	pop	r10
	pop	rcx
	pop	rdx
	pop	rsi
	pop	rdi

	;increment inner count by jump value
	add	r10, rsi
	
	;increment address by jump value
	add	rcx, rsi

	;if not at the end of the message loop back
	cmp	r10, rdi
	jl	inner_loop

	;increment outer address by 1
	inc	rdx

	;increment outer count by 1
	inc	r11

	;if outer count is less than jump value loop back
	cmp	r11, rsi
	jl	outer_loop

	pop	rbp
	ret
