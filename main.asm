; Maura Choudhary
; Project 4
; Main.asm File

	extern validate
	extern split
	extern jump
	extern printf
	extern scanf
	extern square

	section .data
menu_head:	db	"Encryption menu options:", 10
len_menu	equ	$-menu_head

option_d:	db	"d - display current message", 10
len_d		equ	$-option_d

option_r:	db	"r - read new message", 10
len_r		equ	$-option_r

option_s:	db	"s - split encrypt", 10
len_s		equ	$-option_s

option_j:	db	"j - jump encrypt", 10
len_j		equ	$-option_j

option_q:	db	"q - quit program", 10
len_q		equ	$-option_q

prompt1:	db	"Enter option letter -> "
len1		equ	$-prompt1

msg_prompt:	db	"Current message: "
len_msg_p	equ	$-msg_prompt

read_fmt:	db	"%d", 0

write_fmt:	db	"%d", 10, 0

read_prompt:	db	"Enter a new message: "
len_rprompt	equ	$-read_prompt

msg_init:	db	"This is the original message."
len_msg_i	equ	$-msg_init

invalid_msg:	db	"Invalid message, keeping current."
len_invalid	equ	$-invalid_msg

split_prompt:	db	"Enter split value: "
len_split	equ	$-split_prompt

invalid_split	db	"Invalid split value.", 10, "Split value has to be less than message length. Current message length is = "
len_inval_split	equ	$-invalid_split

choice_invalid:	db	"Invalid option, try again.", 10
len_choice	equ	$-choice_invalid

root_fmt:	db	"Enter jump interval between 2-%d-> ", 0

invalid_jump:	db	"Invalid jump value.", 10
len_jump	equ	$-invalid_jump

test:		db	"Test", 10

new_line:	db	10

choice1		db	"d"
choice2		db	"r"
choice3		db	"s"
choice4		db	"j"
choice5		db	"q"

	section	.bss
input_char_buff	resb	1
input_num_buff	resb	1
validate_buff	resb	1000
validate_buff2	resb	1000
msg_buff	resb	1000
msg_len		resb	256
extra		resb	1
first_char	resb	1
last_char	resb	1
split_value	resb	256
root_value	resb	1
jump_value	resb	1

	section .text
	global	main

main:
	
	;initialize the message
	mov	r11b, 29
	mov	[msg_len], r11b

	mov	al, [msg_init]
	mov	[msg_buff], al
	
	xor	r11, r11
	mov	r11, 0
	mov	r8, msg_init
	mov	r10, msg_buff
	xor	r9, r9
	mov	r9b, 1

msginit:
	add	r8, r9
	add	r10, r9
	mov	al, [r8]
	mov	[r10], al
	inc	r11
	cmp	r11, 28
	jge	print_menu
	jmp	msginit          

print_menu:
	;print the menu
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, new_line
	mov	rdx, 1
	syscall

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, menu_head
	mov	rdx, len_menu
	syscall
	
	mov	rax, 1
        mov	rdi, 1
        mov	rsi, option_d
        mov	rdx, len_d
	syscall

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, option_r
	mov	rdx, len_r
	syscall
	
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, option_s
        mov	rdx, len_s
	syscall	

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, option_j
        mov	rdx, len_j
	syscall

	mov	rax, 1
        mov	rdi, 1
        mov	rsi, option_q
        mov	rdx, len_q
	syscall

	mov	rax, 1     	
        mov	rdi, 1
        mov	rsi, prompt1
        mov	rdx, len1
	syscall

	;get user input
	mov	rax, 0
	mov	rdi, 0
	mov	rsi, input_char_buff
	mov	rdx, 1
	syscall

	mov	rax, 0
	mov	rdi, 0
	mov	rsi, extra
	mov	rdx, 1
	syscall


	;jump to correct subroutine
	mov	ah, [input_char_buff]
	mov	al, [choice1]
	cmp	ah, al
	je	display
	
	mov	al, [choice2]
	cmp	ah, al
	je	read


	mov	al, [choice3]

	cmp	ah, al
	je	split_init
	
	mov	al, [choice4]
	cmp	ah, al
	je	jump_init

	mov	al, [choice5]
	cmp	ah, al
	je	exit

	jmp	invalid_choice

display:

	;print current message
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, msg_prompt
	mov	rdx, len_msg_p
	syscall

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, msg_buff
	mov	rdx, [msg_len]
	syscall 

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, new_line
	mov	rdx, 1
	syscall
	jmp	print_menu

read:

	;get user input
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, read_prompt
	mov	rdx, len_rprompt
	syscall

	mov	rax, 0
	mov	rdi, 0
	mov	rsi, validate_buff
	mov	rdx, 1000
	syscall

	;save the length of the new message
	mov	r12, rax
	mov	r9, r12         

	;get first character of the message
	mov	r8, validate_buff
	mov	al, [r8]
	mov	[first_char], al
	mov	rdi, [first_char]
	
	;get last character of the message
	sub	r9, 2
	add	r8, r9
	mov	al, [r8]
	mov	[last_char], al
	mov	rsi, [last_char]
	
	call validate

	;rax is 0, jump to invalid
	cmp	rax, 0
	je	invalid

	;else store message length
	dec	r12
	mov	[msg_len], r12

	;copy in new message
	mov	al, [validate_buff]
        mov	[msg_buff], al
        	
        xor	r11, r11
        mov	r11, 0
        mov	r8, validate_buff
        mov	r10, msg_buff
        xor	r9, r9
        mov	r9b, 1
        
msgmove:
        add	r8, r9
        add	r10, r9
        mov	al, [r8]
        mov	[r10], al
        inc	r11
        cmp	r11, r12

	;when done jump to print menu
        jge	print_menu
        jmp	msgmove

invalid:

	;print error message
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, invalid_msg
	mov	rdx, len_invalid
	syscall

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, new_line
	mov	rdx, 1
	syscall

	jmp	print_menu

split_init:
	
	
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, split_prompt
	mov	rdx, len_split
	syscall

	;read in user input
	push	rbp
	mov	rdi, read_fmt
	mov	rsi, split_value
	call 	scanf
	pop	rbp

	;verify if input is valid
	mov	r12, [split_value]
	mov	r11, [msg_len]	
	
	cmp	r12, r11
	jle	split_valid
	jmp	split_invalid

split_valid:

	;print the current message
	
	mov	rax, 1      	
        mov	rdi, 1
        mov	rsi, msg_prompt
        mov	rdx, len_msg_p
        syscall
                               
        mov	rax, 1
        mov	rdi, 1
        mov	rsi, msg_buff
        mov	rdx, [msg_len]
	syscall                       
	
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, new_line
	mov	rdx, 1
	syscall                   

	;call split function
	mov	rdi, [msg_len]
	mov	rsi, [split_value]
	mov	rdx, msg_buff
	call split

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, new_line
	mov	rdx, 1
	syscall
	jmp	print_menu

split_invalid:

	;print error message
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, invalid_split
	mov	rdx, len_inval_split
	syscall
	
	mov	rdi, write_fmt
	mov	rsi, [msg_len]
	mov	rax, 0
	call printf
	
	;jump back to menu
	jmp	print_menu

jump_init:

	;find the square root of the length
	mov	rdi, [msg_len]
	call	square

	;store square root
	mov	[root_value], rax

	push	rbp
	mov	rdi, root_fmt
	mov	rsi, [root_value]
	mov	rax, 0
	call 	printf
	pop	rbp

	;flushing the buffer
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, extra
	mov	rdx, 0
	syscall
	
	;get a jump value
	push	rbp
	mov	rdi, read_fmt
	mov	rsi, jump_value
	mov	rax, 0
	call	scanf
	pop	rbp

	;verify that jump value is valid
	xor	r11, r11
	xor	r12, r12
	mov	r11b, [root_value]
	mov	r12b, [jump_value]

	cmp	r12, r11
	jg	jump_invalid
	cmp	r12, 2
	jl	jump_invalid

	;if valid print prompt
	mov	rax, 1         	
        mov	rdi, 1
        mov	rsi, msg_prompt
        mov	rdx, len_msg_p
        syscall
                               
        mov	rax, 1
        mov	rdi, 1
        mov	rsi, msg_buff
        mov	rdx, [msg_len]
        syscall                
        
        mov	rax, 1
        mov	rdi, 1
        mov	rsi, new_line
        mov	rdx, 1
        syscall                
	
	;call jump function
	mov	rdi, [msg_len]
	mov	rsi, [jump_value]
	mov	rdx, msg_buff
	call	jump
	
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, new_line
	mov	rdx, 1
	syscall

	jmp	print_menu

jump_invalid:
	;print error message and jump to menu
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, invalid_jump
	mov	rdx, len_jump
	syscall
		
	jmp	print_menu	

invalid_choice:
	;print error message and jump to menu
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, choice_invalid
	mov	rdx, len_choice
	syscall

	jmp	print_menu

exit:
	mov	rax, 60
	mov	rdi, rdi
	syscall

