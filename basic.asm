section .data
msg db 'Hello world!',10
msg_len equ $-msg
msg1 db 'enter your name: ',32
msg1_len equ $-msg1
msg2 db 'enter your prn: ',32
msg2_len equ $-msg2

section .bss
name resb 32
prn resb 32

section .text
global _start
_start:
mov rax,1
mov rdi,1
mov rsi,msg1
mov rdx,msg1_len
syscall

 mov rax, 0          
    mov rdi, 0          
    mov rsi, name  
    mov rdx, 32      
    syscall
   
mov rax,1
mov rdi,1
mov rsi,name
mov rdx,32
syscall

mov rax,1
mov rdi,1
mov rsi,msg2
mov rdx,msg2_len
syscall
   
mov rax,0
mov rdi,0
mov rsi,prn
mov rdx,32
syscall

mov rax,1
mov rdi,1
mov rsi,prn
mov rdx,32
syscall
   
mov rax,1
mov rdi,1
mov rsi,msg
mov rdx,msg_len
syscall

mov rax,60
mov rdi,0
syscall


