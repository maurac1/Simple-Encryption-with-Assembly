; Maura Choudhary
; Project 4
; split.asm


	section .data

prompt:		db	"Shift encryption: "
len_prompt:	equ	$-prompt

new_line:	db	10

	section .bss
new_string_buff	resb	1000
original_buff	resb	1000
len_original	resb	1
char_buff	resb	1

	section .text
	global split

split:
	push	rbp

	;mov parameters to registers
	mov	r11, 1
	mov	r10, rsi

	;print prompt
	push	rdi
	push	rsi
	push	rdx
	push	r10
	push	r11
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, prompt
	mov	rdx, len_prompt
	syscall
	pop	r11
	pop	r10
	pop	rdx
	pop	rsi
	pop	rdi

	;mov to character at split value
	add	rdx, rsi

print_front:

	;print character at current address
	mov	al, [rdx]
	mov	[char_buff], al

	push	rdi
	push	rsi
	push	rdx
	push	r10
	push	r11
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, char_buff
	mov	rdx, 1
	syscall
	pop	r11
	pop	r10
	pop	rdx
	pop	rsi
	pop	rdi

	;move to next character
	add	rdx, r11

	;exit loop or loop back
	inc	r10
	cmp	r10, rdi
	jge	print_back
	jmp	print_front
	


print_back:
	;restart count
	mov	r10, 0

	;move back to first character
	sub	rdx, rdi

loop_back:

	;print current character
	mov	al, [rdx]
	mov	[char_buff], al

	push	rdi
	push	rsi
	push	rdx
	push	r10
	push	r11
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, char_buff
	mov	rdx, 1
	syscall
	pop	r11
	pop	r10
	pop	rdx
	pop	rsi
	pop	rdi

	;move to next character
	add	rdx, r11

	;exit loop or loop back
	inc	r10
	cmp	r10, rsi
	jl	loop_back


	pop	rbp

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, new_line
	mov	rdx, 1
	ret

