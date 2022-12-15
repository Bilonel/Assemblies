
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
    
ENDC

;===========TEST CASE=============    
MOVLW 0
MOVWF direction

MOVLW 1
MOVWF value
    
MOVLW 0
MOVWF count

;=================================
MAIN
    GOTO WHILE_LOOP
    
WAIT
    CALL WAIT_250
    ;CALL WAIT_500
    RETURN
    
    
WHILE_LOOP
    MOVF value,W
    MOVWF PORTD
 
    CALL WAIT

    INCFSZ count
    
    MOVF count,W
    MOVWF temp
    MOVLW 15
    SUBWF temp,W
    BTFSC STATUS,C
    GOTO TURN_ALL_LEDS_TWICE; IF COUNT > 14
    
    MOVF value,W
    MOVWF temp
    MOVLW 127
    SUBWF temp,W
    BTFSC STATUS,C
    CALL CHANGE_DIRECTION ; IF VALUE >127
 	
    GOTO SET_VALUE

    GOTO WHILE_LOOP

CHANGE_DIRECTION
    MOVLW 1
    MOVWF direction
    MOVF value,W
    BCF STATUS,C
    RETURN
SET_VALUE
    BTFSC direction,0
    GOTO SHIFT_RIGHT	; IF DIR == MOVE_RIGHT
    	; IF DIR == MOVE_LEFT
    RLF value,F ; VALUE<<1
    GOTO WHILE_LOOP
SHIFT_RIGHT
    RRF value,F
    GOTO WHILE_LOOP
TURN_ALL_LEDS_TWICE
    
    MOVLW 0
    MOVWF direction

    MOVLW 1
    MOVWF value

    MOVLW 0
    MOVWF count 
    
    CLRF PORTD
    CALL WAIT
    MOVLW 255
    MOVWF PORTD
    CALL WAIT
    CLRF PORTD
    CALL WAIT
    MOVLW 255
    MOVWF PORTD
    CALL WAIT
    CLRF PORTD
    GOTO WHILE_LOOP

WAIT_500
    CALL WAIT_250
    CALL WAIT_250
    RETURN
WAIT_250
    MOVLW 255
    MOVWF temp
    MOVF 250,W
    MOVWF temp2
    GOTO WAIT_250ms
    GOTO WAIT_END
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
    
 