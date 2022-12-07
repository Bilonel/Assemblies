
; BILAL DEMIR | 152120191036 | Group 10

#define	MOVE_LEFT 0
#define	MOVE_RIGHT 1

LIST	P= 16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

 radix dec    

; Reset vector
org 0x00
; ---------- Initialization ---------------------------------
BSF STATUS, RP0 ; Select Bank1
CLRF TRISB ; Set all pins of PORTB as input
CLRF TRISD ; Set all pins of PORTD as output
BCF STATUS, RP0 ; Select Bank0
CLRF PORTB ; Turn off all LEDs connected to PORTB
CLRF PORTD ; Turn off all LEDs connected to PORTD
; ---------- Code starts here --------------------------

CBLOCK 0x20
    direction:1
    value:1
    count:1
    
    temp:1
    temp2:1
    waitSeconds:1
    
    i:1
    count:1
    RESULT_OF_DIV:1
    RL:1
    RH:1
ENDC

;===========TEST CASE=============    
MOVLW MOVE_LEFT
MOVWF direction

MOVLW 11
MOVWF value
    
MOVLW 0
MOVWF count

MOVLW 255
MOVWF waitSeconds
    
;=================================
    
WHILE_LOOP
    MOVF value,W
    MOVWF PORTD
 
    GOTO WAIT

    INCFSZ count
    
    MOVF count,W
    MOVWF temp
    MOVLW 14
    SUBWF temp,W
    BTFSC STATUS,C
    GOTO TURN_ALL_LEDS_TWICE; IF COUNT > 14
    
    ; ELSE
    MOVF value,W
    MOVWF temp
    MOVLW 127
    SUBWF temp,W
    BTFSC STATUS,C
    GOTO CHANGE_DIRECTION ; IF VALUE >127
 	
    GOTO SET_VALUE

    GOTO WHILE_LOOP

CHANGE_DIRECTION
    direction=MOVE_RIGHT
    GOTO SET_VALUE
    RETURN
SET_VALUE
    MOVF dir,W
    BTFSC 0,b
    SHIFT_RIGHT	; IF DIR == MOVE_RIGHT
    	; IF DIR == MOVE_LEFT

    RETURN
SHIFT_RIGHT
    MOVF value,W
    ADDWF value,W
    RETURN
WAIT
    MOVF waitSeconds,W
    MOVWF temp
    MOVF d'250'
    MOVWF temp2
    GOTO WAIT_250ms
    RETURN
WAIT_250ms
    DECFSZ temp2
    GOTO WAIT_1ms
    RETURN
WAIT_1ms
    NOP
    DECFSZ temp
    GOTO WAIT_1ms
    GOTO WAIT_250ms
WAIT_END
    RETURN

_END
    MOVLW 0
    MOVWF PORTD
    LOOP GOTO $ ; Infinite loop
    END 
    
 