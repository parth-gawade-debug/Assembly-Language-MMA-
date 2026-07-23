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
mov [temp] ,ax
mov bp,4
up:rol ax,4
mov bx,ax
and ax,0Fh
cmp al,09
jbe down
add al,07h
down: add al,30h
mov byte[temp],al
rw 1,1,temp,1
mov ax,bx
dec bp
jnz up
 rw 60,0,0,0