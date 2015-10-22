; prints 64 bit unsigned number (in register rax) as decimal string
;
global _start

section .text
_start:
	mov 	rax, 129 ; This number is to be printed
	call printDec
	call exit

exit:
	mov 	rax, 60 ; sys_exit
	mov 	rdi, 0 	; exit code = 0
	syscall

section .bss
deckonv: resb 20

section .text
printDec:
	; zero out memory
	push 	rax
	call clearDec
	pop 	rax
	
	mov 	r15, 10 ; divisor
	lea 	rsi, [deckonv+19]
	
divroutine:
	div 	r15
	add 	dl, 48
	mov 	[rsi], dl ; remainder
	cqo
	dec 	rsi
	test 	rax,rax
	jnz 	divroutine
	
	mov 	rsi, deckonv
	mov 	rdx, 20
	mov 	rdi, 1
	mov 	rax, 1
	syscall
	ret

clearDec:
	mov 	rcx, 20
	mov 	rdi, deckonv
	xor 	rax,rax
	rep stosb ; decrements rcx by 1, stores al in [rdi] and increments rdi
	ret

; prints rax as 16-digit hex string 
printHex:
	mov 	r14b, 10 ; base 10 	
	mov 	r15b, 16
cycleAgain:
	rol 	rax, 4
	
	; separate 4 bits
	mov 	bl, 0x0F
	and 	bl, al
	and 	al, 0xF0
	
	; if <10 then 0-9 else A-F
	cmp 	bl, r14b
	jl 		isdigit
	add 	bl, 7
isdigit:
	add 	bl, 48
	
	; print digit
	mov 	r8, rax	

	mov 	[bytestr], bl
	mov 	rsi, 	bytestr
	mov 	rax, 	1
	mov 	rdi, 	1
	mov 	rdx, 	1
	syscall
	
	mov 	rax, r8
	dec 	r15b
	test 	r15b, r15b
	jne 	cycleAgain

	ret

writeNewline:
	mov 	rsi, 	newline
	mov 	rdx, 	1 		; length
	mov 	rax, 	1		; sys_write
	mov 	rdi, 	1		; write to stdout
	syscall
	ret

section .data
bytestr: db 	1
newline: db 	0x0A
