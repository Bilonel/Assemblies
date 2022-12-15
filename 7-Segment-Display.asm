; BILAL DEMIR | 152120191036 | Group 10

#define	firstDigit 3
#define	secondDigit 4

LIST	P= 16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

radix dec    
; Reset vector
org 0x00
; ---------- Initialization ---------------------------------
BSF STATUS, RP0 ; Select Bank1
CLRF TRISA ; Set all pins of PORTB as output
CLRF TRISD ; Set all pins of PORTD as output
BCF STATUS, RP0 ; Select Bank0
CLRF PORTA ; Turn off all LEDs connected to PORTB
CLRF PORTD ; Turn off all LEDs connected to PORTD
BSF PORTA,3
 
; ---------- Code starts here --------------------------

CBLOCK 0x20
    digit0:1
    digit1:1
    
    temp:1
    NoIteration:1
ENDC

;===========TEST CASE=============    
MOVLW 90
MOVWF NoIteration
;================================
    
While_
    MOVLW 90
    MOVWF NoIteration
    CALL forLoop
    
    INCF digit0
    
    MOVF digit0,W
    MOVWF temp
    MOVLW 10
    SUBWF temp,W
    BTFSC STATUS,C
    CALL SET_FIRST_DIGIT; IF temp(digit0) > 10
    
    BTFSC digit1,1	; if digit1 != 2	SKIP
    BTFSS digit0,0	; if digit0 == 1	SKIP	
    GOTO While_		; Digit1 != 2 OR Digit0 != 1
    GOTO Reset_		; Digit1 = 2 AND Digit0 = 1
Reset_
    CLRF PORTD
    CLRF digit0
    CLRF digit1
    GOTO While_
SET_FIRST_DIGIT
    CLRF digit0
    INCF digit1
    RETURN   
forLoop
    BSF PORTA,secondDigit   ; SELECT SECOND DIGIT
    BCF PORTA,firstDigit    ; DESELECT FIRST DIGIT
    MOVF digit0,W	    ; WREG = digit0
    CALL DisplayNumber	    ; PORTD = WREG
    CALL Delay_5ms
    
    BSF PORTA,firstDigit    ; SELECT FIRST DIGIT
    BCF PORTA,secondDigit   ; DESELECT SECOND DIGIT
    MOVF digit1,W	    ; WREG = digit1
    CALL DisplayNumber	    ; PORTD = WREG
    CALL Delay_5ms
    
    DECFSZ NoIteration
    GOTO forLoop
    RETURN

DisplayNumber
    CALL GetDecimal ; WREG = DISPLAY CODE OF WREG
    
    MOVWF PORTD	    ; PORTD = DISPLAY CODE
    RETURN
GetDecimal
    ADDWF PCL, F
    RETLW B'00111111'	;0
    RETLW B'00000110'	;1
    RETLW B'01011011'	;2
    RETLW B'01001111'	;3
    RETLW B'01100110'	;4
    RETLW B'01101101'	;5
    RETLW B'01111101'	;6
    RETLW B'00000111'	;7
    RETLW B'01111111'	;8
    RETLW B'01101111'	;9
Delay_5ms
    Call Delay_1ms
    Call Delay_1ms
    Call Delay_1ms
    Call Delay_1ms
    Call Delay_1ms
    RETURN
Delay_1ms 
    MOVLW 250
    MOVWF temp
    CALL wait_4us   ; 250 TIMES = 1 MS
    RETURN
wait_4us	    ; 3 microSeconds
    NOP
    DECFSZ temp
    GOTO wait_4us
    RETURN
    
END_ 
    CLRF PORTA
    LOOP GOTO $ ; Infinite loop
    END 
