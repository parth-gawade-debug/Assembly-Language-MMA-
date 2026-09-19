section .data

    arr db 25h, 12h, 45h, 09h, 31h
    msg db "Sorted array in HEX:", 10
    msglen equ $ - msg

section .bss
    result resb 20
bits 64
section .text
    global _start

_start:

    mov bl, 5

loop_outer:
    mov cl, 4
    mov rsi, arr

up:
    mov al, byte [rsi]
    cmp al, byte [rsi + 1]
    jbe only_inc

    xchg al, byte [rsi + 1]
    mov byte [rsi], al

only_inc:
    inc rsi
    dec cl
    jnz up

    dec bl
    jnz loop_outer


    ; Display message

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msglen
    syscall


    ; Display sorted array

    mov rdi, arr
    mov rsi, result
    mov dl, 5

disp_loop:

    mov al, byte [rdi]
    mov bl, al

    ; First digit

    shr al, 4
    cmp al, 09H
    jbe first_digit

    add al, 07H

first_digit:
    add al, 30H
    mov byte [rsi], al

    ; Second digit

    mov al, bl
    and al, 0FH
    cmp al, 09H
    jbe second_digit

    add al, 07H

second_digit:
    add al, 30H
    mov byte [rsi + 1], al

    ; Add H and space

    mov byte [rsi + 2], 'H'
    mov byte [rsi + 3], ' '

    add rsi, 4
    inc rdi

    dec dl
    jnz disp_loop


    ; Display result

    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 20
    syscall


    ; Exit

    mov rax, 60
    mov rdi, 0
    syscall