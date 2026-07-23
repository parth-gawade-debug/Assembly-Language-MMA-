%macro rw 4
    mov rax,%1
    mov rdi,%2
    mov rsi,%3
    mov rdx,%4
    syscall
%endmacro

bits 64

section .data
num1 db 5h
num2 db 9h
section .bss
temp resb 1

section .text
global _start
_start:
mov ax,[num1]
add ax,[num2]
add ax, 37h  ;we will use 30 for numbers less than 9 and 37 for >9
mov [temp] ,ax
rw 1,1,temp,1
 rw 60,0,0,0