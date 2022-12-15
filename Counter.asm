; BILAL DEMIR | 152120191036 | Group 10

#define	BUTTON	PORTB, 3	; RB3
LIST	P= 16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

 radix dec    

; Reset vector
org 0x00
; ---------- Initialization ---------------------------------
BSF STATUS, RP0 ; Select Bank1
MOVLW 255
MOVWF TRISB ; Set all pins of PORTB as output
CLRF TRISD ; Set all pins of PORTD as output
BCF STATUS, RP0 ; Select Bank0
CLRF PORTB ; Turn off all LEDs connected to PORTB
CLRF PORTD ; Turn off all LEDs connected to PORTD
; ---------- Your code starts here --------------------------
CBLOCK 0x20
    zib0:1
    zib1:1
    zib:1
    
    i:1
    N:1
    
    state1:1
    state2:1
    
    temp:1
    waitSeconds:1
    temp2:1
ENDC
    
;===========TEST CASE=============    
MOVLW 1
MOVWF zib0

MOVLW 2
MOVWF zib1

MOVLW 2
MOVWF i
    
MOVLW 13
MOVWF N
    
MOVLW 63
MOVWF state1

MOVLW 5
MOVWF state2    

MOVLW 255
MOVWF waitSeconds
   
;=================================
MOVLW d'1'
ADDWF N
    
CALL FOR_LOOP_BEGIN
GOTO _END
    
FOR_LOOP_BEGIN
    MOVF i,W
    MOVWF temp
    MOVF N,W
    SUBWF temp,W
    BTFSC STATUS,C
    GOTO i_GREATER_THAN_N
    
    MOVF state1,W   ; ---------STATE 1
    MOVWF temp	; TEMP = 0X3F
    MOVF zib1,W
    ANDWF temp	; TEMP = TEMP && ZIB1
    MOVF temp,W
    MOVWF zib	;ZIB = TEMP
    
    MOVF state2,W   ; ---------STATE 2
    MOVWF temp	; TEMP = 0X05
    MOVF zib0,W	; W = ZIB0
    IORWF temp	; TEMP = TEMP || ZIB0
    MOVF temp,W	; W =TEMP
    ADDWF zib	;ZIB += TEMP
    
    MOVF zib1,W
    MOVWF zib0	; ZIB0=ZIB1
    MOVF zib,W
    MOVWF zib1	; ZIB1=ZIB
    
    MOVWF PORTD ; PORTD = ZIB
    
    GOTO WAIT
    
    
i_GREATER_THAN_N
    RETURN
    
WAIT
    MOVF waitSeconds,W
    MOVWF temp
    MOVF d'250'
    MOVWF temp2
    GOTO WAIT_250ms
WAIT_250ms
    DECFSZ temp2
    GOTO WAIT_1ms
    GOTO WAIT_END
WAIT_1ms
    NOP
    DECFSZ temp
    GOTO WAIT_1ms
    GOTO WAIT_250ms
WAIT_END
    INCF i,F
    GOTO WHILE_LOOP
WHILE_LOOP
    BTFSC PORTB,3
    GOTO WHILE_LOOP
    GOTO WHILE_END
WHILE_END
    GOTO FOR_LOOP_BEGIN
_END
    LOOP GOTO $ ; Infinite loop
    END

