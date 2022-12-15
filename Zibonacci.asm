
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
MOVLW 255 ; 0xFF
MOVWF TRISB ; Set all pins of PORTB as input
CLRF TRISD ; Set all pins of PORTD as output
BCF STATUS, RP0 ; Select Bank0
CLRF PORTB ; Turn off all LEDs connected to PORTB
CLRF PORTD ; Turn off all LEDs connected to PORTD
; ---------- Code starts here --------------------------

CBLOCK 0x20
    x:1
    y:1
    N:1
    
    sum:1
    A:40
    
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
MOVLW 7
MOVWF x

MOVLW 11
MOVWF y
    
MOVLW 23
MOVWF N

MOVLW 0
MOVWF i    
    
MOVLW 0
MOVWF count

MOVLW 0
MOVWF sum  

MOVLW 255
MOVWF waitSeconds
    
;=================================
    
Main  
    
    
    
    MOVLW A
    MOVWF FSR
    GOTO GENERATE_NUMBERS

GENERATE_NUMBERS
    MOVF x,W
    MOVWF temp
    MOVF N,W
    SUBWF temp,W
    BTFSC STATUS,C
    GOTO X_Not      ;  / x_GREATER_THAN_N
    GOTO ONE_ITERATION
X_Not
    MOVF y,W
    MOVWF temp
    MOVF N,W
    SUBWF temp,W
    BTFSC STATUS,C
    GOTO Y_Not      ;  / y_GREATER_THAN_N
    GOTO ONE_ITERATION
Y_Not
    GOTO CALCULATE_SUM
ONE_ITERATION
    
    CLRF temp
    MOVF y,W
    ADDWF temp
    MOVF x,W
    ADDWF temp
    
    BTFSS temp,0
    GOTO EVEN_ITERATION
    GOTO ODD_ITERATION
EVEN_ITERATION
    GOTO Divide
Divide_End
    MOVF RESULT_OF_DIV,W
    MOVWF INDF
    INCF FSR,F
    INCF count,F
    MOVLW 3
    ADDWF y
    GOTO GENERATE_NUMBERS
ODD_ITERATION
    GOTO MULTIPLY
MULTIPLY_END
    CLRF temp
    MOVF RL,W
    ADDWF temp
    ADDWF temp
    MOVF RH,W
    ADDWF temp
    MOVF temp,W
    MOVWF INDF
    INCF FSR,F
    INCF count,F
    MOVLW 1
    ADDWF x
    GOTO GENERATE_NUMBERS
    
CALCULATE_SUM
    MOVLW A
    MOVWF FSR
    INCF count,F
    GOTO loop_start
loop_start
    DECFSZ count
    GOTO loop
    GOTO DISPLAY_START ; if i>count 
loop
    MOVF INDF,W
    ADDWF sum
    INCF FSR,F
    GOTO loop_start
DISPLAY_START  
    MOVF sum,W
    MOVWF PORTD ; PORTD = SUM

    MOVLW A
    MOVWF FSR
    
    GOTO DISPLAY
DISPLAY
    GOTO WHILE_LOOP
DISPLAY_LOOP
    MOVF i,W
    MOVWF temp
    MOVLW 5
    SUBWF temp,W
    BTFSC STATUS,C
    GOTO DISPLAY_END      ;  / i_GREATER_THAN_5
    MOVF INDF,W
    MOVWF PORTD ; PORTD = ZIB
    INCF i,F
    INCF FSR,F
    GOTO WAIT
DISPLAY_END
    GOTO _END
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
    GOTO WHILE_LOOP
WHILE_LOOP
    BTFSC PORTB,3
    GOTO WHILE_LOOP
    GOTO WHILE_END
WHILE_END
    GOTO DISPLAY_LOOP
   
Divide
    CLRF RESULT_OF_DIV
    
    MOVF 3, F
    BTFSC STATUS,Z
    GOTO Divide_End
    GOTO Divide_Loop
Divide_Loop
    MOVLW 3
    SUBWF temp,W
    BTFSS STATUS, C
    GOTO Divide_End
    
    MOVWF temp
    INCF RESULT_OF_DIV,F
    GOTO Divide_Loop
MULTIPLY
    MOVF y,W
    MOVWF temp2
    CLRF RL
    CLRF RH
    MOVF y,W
    BTFSC STATUS,Z
    GOTO MULTIPLY_END
    MOVFW x
Multi_Loop
    ADDWF RL,F
    BTFSC STATUS,C
    INCF RH,F
    DECFSZ temp2,F
    GOTO Multi_Loop
    GOTO MULTIPLY_END
_END
    MOVLW 0
    MOVWF PORTD
    LOOP GOTO $ ; Infinite loop
    END 
    
 