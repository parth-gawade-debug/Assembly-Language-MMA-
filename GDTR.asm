section .data
msg1 db "Base Address : ",10
msgl1 equ $-msg1
msg2 db "Offset : ",10
msgl2 equ $-msg2
msg3 db "Global descriptor table register",10
msgl3 equ $-msg3
%macro operate 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro
section .bss
gdtr resq 1 ;quad word=64 bits
gdtlimit resw 1
temp64 resq 1
temp16 resw 1
asc resq 1
section .text
global _start
_start:
operate 1,1,msg3,msgl3 ;Global descriptor table register-GDTR
operate 1,1,msg1,msgl1 ;Base Address 8 bytes (64 Bits)
mov rsi,gdtr
sgdt [rsi]
mov rax,[rsi+2]
;move contents of rsi in rax
call display64
operate 1,1,msg2,msgl2 ;Offset-Limit 16 Bits
mov rsi,gdtlimit
mov ax,[rsi]
call display16

operate 60,0,0,0
display64:
mov bp,16
again1:
rol rax,4
mov [temp64],rax
and rax,0FH
cmp rax,09H
jbe skip64
add al,07H
skip64 :
add al,30H
mov [asc],al
operate 1,1,asc,1
mov rax,[temp64]
dec bp
jnz again1
ret
display16:
mov bp,4
again2:
rol ax,4
mov [temp16],ax
and ax,0FH
cmp al,09H
jbe skip16
add al,07H
skip16 :
add al,30H
mov [asc],al
operate 1,1,temp,1
mov ax,[res16]
dec bp
jnz again2
ret