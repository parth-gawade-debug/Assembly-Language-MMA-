;=============================================================
; LCD Petrol Price Display for EdSim51 Simulator
; Line 1 : "PETROL"
; Line 2 : "104.05"
; Pins Map : P1.7-P1.4 = DB7-DB4, P1.3 = RS, P1.2 = E
;=============================================================

;-------------------------------------------------------------
; Reset vector
;-------------------------------------------------------------
ORG 0000H
LJMP MAIN

;-------------------------------------------------------------
; Main program
;-------------------------------------------------------------
ORG 0030H
MAIN:
    MOV SP, #60H        ; Setup Stack Pointer
    LCALL LCD_INIT      ; Initialize the LCD module

    ; --- PRINT FIRST LINE ("PETROL") ---
    MOV DPTR, #LINE1_MSG 
PRINT_L1:
    CLR A
    MOVC A, @A+DPTR     
    JZ MOVE_TO_L2       ; Stop printing line 1 if 00H is reached
    LCALL LCD_DATA      
    INC DPTR            
    CALL DELAY          
    SJMP PRINT_L1

MOVE_TO_L2:
    ; --- MOVE CURSOR TO LINE 2 (Command 0xC0) ---
    CLR P1.3            ; Select Instruction Register (RS = 0)
    MOV A, #0C0H
    
    ; Send high nibble (C)
    MOV C, 0E7H
    MOV P1.7, C
    MOV C, 0E6H
    MOV P1.6, C
    MOV C, 0E5H
    MOV P1.5, C
    MOV C, 0E4H
    MOV P1.4, C
    SETB P1.2
    CLR P1.2
    
    ; Send low nibble (0)
    MOV C, 0E3H
    MOV P1.7, C
    MOV C, 0E2H
    MOV P1.6, C
    MOV C, 0E1H
    MOV P1.5, C
    MOV C, 0E0H
    MOV P1.4, C
    SETB P1.2
    CLR P1.2
    CALL DELAY

    ; --- PRINT SECOND LINE ("104.05") ---
    MOV DPTR, #LINE2_MSG 
PRINT_L2:
    CLR A
    MOVC A, @A+DPTR     
    JZ MAIN_END         ; Stop printing line 2 if 00H is reached
    LCALL LCD_DATA      
    INC DPTR            
    CALL DELAY          
    SJMP PRINT_L2

MAIN_END:
    SJMP MAIN_END       ; Infinite halt loop

;-------------------------------------------------------------
; LCD_INIT: Official EdSim51 4-bit Setup Sequence
;-------------------------------------------------------------
LCD_INIT:
    CLR P1.3            ; Select Instruction Register (RS = 0)

    ; --- Function Set (First Step) ---
    CLR P1.7
    CLR P1.6
    SETB P1.5
    CLR P1.4            ; High nibble 20H
    SETB P1.2
    CLR P1.2
    CALL DELAY

    ; --- Function Set (Second Step) ---
    SETB P1.2
    CLR P1.2
    SETB P1.7           ; Sets 2-Line mode (28H)
    SETB P1.2
    CLR P1.2
    CALL DELAY

    ; --- Entry Mode Set ---
    CLR P1.7
    CLR P1.6
    CLR P1.5
    CLR P1.4
    SETB P1.2
    CLR P1.2
    SETB P1.6
    SETB P1.5           ; Auto-Increment cursor
    SETB P1.2
    CLR P1.2
    CALL DELAY

    ; --- Display ON/OFF Control ---
    CLR P1.7
    CLR P1.6
    CLR P1.5
    CLR P1.4
    SETB P1.2
    CLR P1.2
    SETB P1.7
    SETB P1.6
    SETB P1.5
    SETB P1.4           ; Display ON, Cursor ON
    SETB P1.2
    CLR P1.2
    CALL DELAY
    RET

;-------------------------------------------------------------
; LCD_DATA: Sends 8-bit character data split into two 4-bit blocks
;-------------------------------------------------------------
LCD_DATA:
    SETB P1.3           ; Select Data Register (RS = 1)

    ; --- Transmit High Nibble ---
    MOV C, 0E7H
    MOV P1.7, C
    MOV C, 0E6H
    MOV P1.6, C
    MOV C, 0E5H
    MOV P1.5, C
    MOV C, 0E4H
    MOV P1.4, C
    SETB P1.2
    CLR P1.2

    ; --- Transmit Low Nibble ---
    MOV C, 0E3H
    MOV P1.7, C
    MOV C, 0E2H
    MOV P1.6, C
    MOV C, 0E1H
    MOV P1.5, C
    MOV C, 0E0H
    MOV P1.4, C
    SETB P1.2
    CLR P1.2

    CALL DELAY
    RET

;-------------------------------------------------------------
; Standard Hardware Execution Delay Subroutine
;-------------------------------------------------------------
DELAY:
    MOV R0, #50
DJNZ R0, $
    RET

;-------------------------------------------------------------
; Numeric ASCII Table for Project Text Strings
;-------------------------------------------------------------
LINE1_MSG:
    DB 50H, 45H, 54H, 52H, 4FH, 4CH, 00H        ; P E T R O L [null]

LINE2_MSG:
    DB 31H, 30H, 34H, 2EH, 30H, 35H, 00H        ; 1 0 4 . 0 5 [null]

END




This is the final working code with 0 errors for our project of displaying petrol rate on a lcd using edsim 8051 microcontroller explain me the whole code so that we can present it with complete logic of code
