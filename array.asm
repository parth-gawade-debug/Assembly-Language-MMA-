section .data
Num_array db 16h,17h,18h,19h,20h
msg db"result of array addition is",10
msglen equ $-msg
section .bss
result resw 1
temp resw 2
temp1 resb 1
bits 64
%macro rw 4
    mov rax,%1
    mov rdi,%2
    mov rsi,%3
    mov rdx,%4
    syscall
%endmacro
section .text
global _start
_start:
rw 1,1,msg,msglen
mov rsi,Num_array
mov ax,00h
mov cl,5

up2: add al, byte[rsi]
jnc skip
inc ah
skip:
inc rsi
dec cl
jnz up2
mov bp,4
up: rol ax,4
mov bx,ax
and ax,0fh
cmp al,09
jbe down
add al,07h
down:add al,30h
mov byte[temp],al
rw 1,1,temp,1
mov ax,bx
dec bp
jnz up
rw 60,0,0,0