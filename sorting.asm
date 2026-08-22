section .data
    arr         db 0xA3, 0x9B, 0x0F, 0x25, 0x90
    len         equ 5

    m_orig      db "Original   : "
    m_orig_len  equ $-m_orig

    m_asc       db 10,"Ascending  : "
    m_asc_len   equ $-m_asc

    m_desc      db 10,"Descending : "
    m_desc_len  equ $-m_desc

    m_cmpx      db 10,10,"CMPXCHG demo -> compare arr[0] with 0xA3, replace with 0x55 if equal:"
    m_cmpx_len  equ $-m_cmpx

    m_before    db 10,"  Before: "
    m_before_len equ $-m_before

    m_after     db 10,"  After : "
    m_after_len equ $-m_after

    m_zf1       db " (ZF=1 -> match, value replaced)",10
    m_zf1_len   equ $-m_zf1

    m_zf0       db " (ZF=0 -> no match, AL loaded with actual value)",10
    m_zf0_len   equ $-m_zf0

    m_bswap     db 10,"BSWAP demo -> first 4 bytes read as one 32-bit value:"
    m_bswap_len equ $-m_bswap

    m_bbefore   db 10,"  Before BSWAP: "
    m_bbefore_len equ $-m_bbefore

    m_bafter    db 10,"  After BSWAP : "
    m_bafter_len equ $-m_bafter

    space       db " "
    nl          db 10

section .bss
    hexbuf      resb 2

section .text
    global _start

_start:
    ; ---------- print original array ----------
    mov ecx, m_orig
    mov edx, m_orig_len
    call print_str
    call print_array

    ; ---------- ascending sort (CMP + XCHG) ----------
    call sort_ascending
    mov ecx, m_asc
    mov edx, m_asc_len
    call print_str
    call print_array

    ; ---------- descending sort (CMP + XCHG, flipped test) ----------
    call sort_descending
    mov ecx, m_desc
    mov edx, m_desc_len
    call print_str
    call print_array

    ; ---------- CMPXCHG demonstration ----------
    mov ecx, m_cmpx
    mov edx, m_cmpx_len
    call print_str

    mov ecx, m_before
    mov edx, m_before_len
    call print_str
    mov al, [arr]
    call print_hex_al

    mov al, 0xA3            ; AL = expected value (CMPXCHG always compares against AL)
    mov bl, 0x55            ; BL = new value to store if match succeeds
    cmpxchg [arr], bl       ; compare AL with [arr]; equal -> [arr]=bl, ZF=1
                            ; not equal -> AL=[arr], ZF=0
    pushf                   ; save ZF before the print calls disturb the flags

    mov ecx, m_after
    mov edx, m_after_len
    call print_str
    mov al, [arr]
    call print_hex_al

    popf
    jz cmpx_match
    mov ecx, m_zf0
    mov edx, m_zf0_len
    call print_str
    jmp cmpx_done
cmpx_match:
    mov ecx, m_zf1
    mov edx, m_zf1_len
    call print_str
cmpx_done:

    ; ---------- BSWAP demonstration ----------
    mov ecx, m_bswap
    mov edx, m_bswap_len
    call print_str

    mov ecx, m_bbefore
    mov edx, m_bbefore_len
    call print_str
    mov eax, [arr]          ; load arr[0..3] as one 32-bit value
    call print_hex_eax

    bswap eax                ; reverse byte order of EAX
    mov ecx, m_bafter
    mov edx, m_bafter_len
    call print_str
    call print_hex_eax

    mov ecx, nl
    mov edx, 1
    call print_str

    ; ---------- exit ----------
    mov eax, 1
    xor ebx, ebx
    int 0x80


; ================= SORT ROUTINES =================

; Bubble sort ascending using CMP + XCHG
sort_ascending:
    mov ecx, len-1
.outer:
    push ecx
    mov esi, arr
    mov ecx, len-1
.inner:
    mov al, [esi]
    cmp al, [esi+1]         ; compare adjacent bytes
    jbe .noswap
    xchg al, [esi+1]        ; swap register <-> memory in one instruction
    mov [esi], al
.noswap:
    inc esi
    loop .inner
    pop ecx
    loop .outer
    ret

; Bubble sort descending: identical logic, comparison flipped
sort_descending:
    mov ecx, len-1
.outer:
    push ecx
    mov esi, arr
    mov ecx, len-1
.inner:
    mov al, [esi]
    cmp al, [esi+1]
    jae .noswap
    xchg al, [esi+1]
    mov [esi], al
.noswap:
    inc esi
    loop .inner
    pop ecx
    loop .outer
    ret


; ================= PRINT HELPERS =================

; print_str: ecx = buffer address, edx = length
print_str:
    pusha
    mov eax, 4              ; sys_write
    mov ebx, 1              ; fd = stdout
    int 0x80
    popa
    ret

; print_array: prints each byte of arr as 2-digit hex, space separated
print_array:
    mov esi, arr
    mov ecx, len
.loop:
    mov al, [esi]
    call print_hex_al        ; preserves esi & ecx internally
    push esi
    push ecx
    mov ecx, space
    mov edx, 1
    call print_str
    pop ecx
    pop esi
    inc esi
    loop .loop
    ret

; print_hex_al: prints AL as a 2-digit hex ASCII pair (caller's regs untouched)
print_hex_al:
    pusha
    mov bl, al
    shr al, 4
    call nibble_to_ascii
    mov [hexbuf], al
    mov al, bl
    and al, 0x0F
    call nibble_to_ascii
    mov [hexbuf+1], al
    mov ecx, hexbuf
    mov edx, 2
    call print_str
    popa
    ret

; print_hex_eax: prints EAX as 8 hex digits, most significant byte first
print_hex_eax:
    mov ecx, 4
    mov edx, eax
.byteloop:
    rol edx, 8               ; rotate next byte into DL
    mov al, dl
    call print_hex_al
    loop .byteloop
    ret

; nibble_to_ascii: AL (0-15) -> ASCII hex character in AL
nibble_to_ascii:
    cmp al, 9
    jbe .digit
    add al, 'A'-10
    ret
.digit:
    add al, '0'
    ret