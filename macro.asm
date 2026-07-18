%macro rw 4
    mov rax,%1
    mov rdi,%2
    mov rsi,%3
    mov rdx,%4
    syscall
%endmacro

bits 64

section .data

arc db "Input your name: ",10
arcLen equ $-arc

bcd db "Input your PRN: ",10
bcdLen equ $-bcd

fgh db "Input your Division: ",10
fghLen equ $-fgh

section .bss

msg resb 30
klm resb 30
abc resb 30

section .text
global _start

_start:

    rw 1,1,arc,arcLen
    rw 0,0,msg,30

    rw 1,1,bcd,bcdLen
    rw 0,0,klm,30

    rw 1,1,fgh,fghLen
    rw 0,0,abc,30
   
    rw 60,0,0,0