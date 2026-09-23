section .data 
    msg1 db "error",10
    msg1len equ $-msg1
    msg2 db "file copy successfully",10
    msg2len equ $-msg2

%macro operate 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
%endmacro
section .bss
    filename1 resb 15
    fd1 resq 1
    filename2 resb 15
    fd2 resq 1
    buff resb 512
    bufflen resq 1
    bits 64
     section .text
        global _start
        _start:
        pop r8
        cmp r8,3
        jne err
        pop r8
        pop r8
        mov rsi,filename1

above:
    mov al,[r8]
    cmp al,00
    je next
    mov [rsi],al
    inc r8
    inc rsi
    jmp above
next:
    pop r8
    mov rsi,filename2
above2:
    mov al,[r8]
    cmp al,00
    je next2
    mov [rsi],al
    inc r8
    inc rsi
    jmp above2

next2:
    operate 2,filename1,000000q,0777q
    mov [fd1],rax

    operate 0,[fd1],buff,512
    mov[bufflen],rax
    operate 85,filename2,0777q,0
    operate 2,filename2,2,0777q
    mov [fd2],rax
    operate 1,[fd2],buff,[bufflen]
    operate 3,[fd2],0,0
    operate 3,[fd1],0,0
    operate 1,1,msg2,msg2len
    jmp end
    err:
        operate 1,1,msg1,msg1len
    end:
        operate 60,0,0,0