; BILAL DEMIR | 152120191036 | Group 10

LIST	P= 16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

 radix dec    

; Reset vector
org 0x00
; ---------- Initialization ---------------------------------
BSF STATUS, RP0 ; Select Bank1
CLRF TRISB ; Set all pins of PORTB as output
CLRF TRISD ; Set all pins of PORTD as output
BCF STATUS, RP0 ; Select Bank0
CLRF PORTB ; Turn off all LEDs connected to PORTB
CLRF PORTD ; Turn off all LEDs connected to PORTD
; ---------- Your code starts here --------------------------
CBLOCK 0x20
    x:1
    y:1
    z:1
    
    r:1
    
    r1:1
    r2:1
    r3:1
    r4:1
    
    FIRST_NUMBER_TO_MULTIPLY:1
    SECOND_NUMBER_TO_MULTIPLY:1
    RESULT_OF_MULTIPLY:1
ENDC
    
;===========TEST CASE=============    
MOVLW 6
MOVWF x

MOVLW 7
MOVWF y

MOVLW 8
MOVWF z
;=================================
   
;-------FIND R1-------------------------
MOVLW 0
MOVWF r1
    
; --- r1 += (5*x) ----
MOVLW 5
MOVWF FIRST_NUMBER_TO_MULTIPLY
MOVF x,W
MOVWF SECOND_NUMBER_TO_MULTIPLY
    CALL Multi8x8
MOVF RESULT_OF_MULTIPLY, W
ADDWF r1			

; --- r1 += z ----
MOVF z,W
ADDWF r1
; --- r1 -= 3 ----
MOVLW 3
SUBWF r1
; --- r1 -= (2*y) ----
MOVLW 2
MOVWF FIRST_NUMBER_TO_MULTIPLY
MOVF y,W
MOVWF SECOND_NUMBER_TO_MULTIPLY  
    CALL Multi8x8
MOVF RESULT_OF_MULTIPLY, W
SUBWF r1
;---------R1 Found----------------------
;+++++++++++++++++++++++++++++++++++++++
;-------FIND R2-------------------------
MOVLW 0
MOVWF r2
    
; --- r2 += [(x+5)*4] -----
MOVF x,W
MOVWF FIRST_NUMBER_TO_MULTIPLY
MOVLW 5
ADDWF FIRST_NUMBER_TO_MULTIPLY ; = X+5
MOVLW 4
MOVWF SECOND_NUMBER_TO_MULTIPLY ; = 4
    CALL Multi8x8
MOVF RESULT_OF_MULTIPLY, W ; = (X+5)*4
ADDWF r2			

; --- r2 += z ----
MOVF z,W
ADDWF r2
; --- r2 -= (3*y) ----
MOVLW 3
MOVWF FIRST_NUMBER_TO_MULTIPLY
MOVF y,W
MOVWF SECOND_NUMBER_TO_MULTIPLY  
    CALL Multi8x8
MOVF RESULT_OF_MULTIPLY, W
SUBWF r2
;---------R2 Found---------------------
;++++++++++++++++++++++++++++++++++++++
;---------FIND R3 -------------------------
;---- r3 += x/2 ---
CLRF r3
MOVF x,W
MOVWF FIRST_NUMBER_TO_MULTIPLY
MOVLW 2
MOVWF SECOND_NUMBER_TO_MULTIPLY  
    CALL Divide
MOVF RESULT_OF_MULTIPLY, W  ; WREG = x/2
ADDWF r3
;---- r3 += y/2 ---
MOVF y,W
MOVWF FIRST_NUMBER_TO_MULTIPLY
MOVLW 2
MOVWF SECOND_NUMBER_TO_MULTIPLY  
    CALL Divide
MOVF RESULT_OF_MULTIPLY, W  ; WREG = x/2
ADDWF r3
;---- r3 += z/4 ---
MOVF z,W
MOVWF FIRST_NUMBER_TO_MULTIPLY
MOVLW 4
MOVWF SECOND_NUMBER_TO_MULTIPLY  
    CALL Divide
MOVF RESULT_OF_MULTIPLY, W  ; WREG = x/2
ADDWF r3
;---------R3 FOUND ----------------------
;++++++++++++++++++++++++++++++++++++++++
;-----------FIND R4------------------------------
CLRF r4 ; r4=0
; --- r4 += 3*x
MOVF x, W
MOVWF FIRST_NUMBER_TO_MULTIPLY
MOVLW 3
MOVWF SECOND_NUMBER_TO_MULTIPLY  
    CALL Multi8x8
MOVF RESULT_OF_MULTIPLY, W
ADDWF r4
; --- r4-=y
MOVF y,W
SUBWF r4
; --- r4 -= 3*z
MOVF z, W
MOVWF FIRST_NUMBER_TO_MULTIPLY
MOVLW 3
MOVWF SECOND_NUMBER_TO_MULTIPLY  
    CALL Multi8x8
MOVF RESULT_OF_MULTIPLY, W
SUBWF r4
; --- r4 *=2 
MOVF r4,W
ADDWF r4
; --- r4 -= 30
MOVLW 30
SUBWF r4
;--------R4 FOUND ------------------------
;+++++++++++++++++++++++++++++++++++++++++
;---------FIND R -------------------------------
clrf r
; --- r+= 3 * r1
MOVF r1,W
addwf r
addwf r    
addwf r    
; ---- r+= 2 * r2
MOVF r2,W
addwf r
addwf r
; ---- r-= r3/2
MOVF r3,W
MOVWF FIRST_NUMBER_TO_MULTIPLY
MOVLW 2
MOVWF SECOND_NUMBER_TO_MULTIPLY  
    CALL Divide
MOVF RESULT_OF_MULTIPLY, W  ; WREG = x/2
SUBWF r
; ---- r -= r4
MOVF r4,W
SUBWF r
;--------------R FOUND---------------
    
    
MOVF r,W ; Store result in WREG
MOVWF PORTD ; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP GOTO $ ; Infinite loop

Multi8x8
    CLRF RESULT_OF_MULTIPLY
    MOVF SECOND_NUMBER_TO_MULTIPLY,F
    BTFSC STATUS,Z
    GOTO Multi_End
    
    MOVFW FIRST_NUMBER_TO_MULTIPLY
Multi8x8_Loop
    ADDWF RESULT_OF_MULTIPLY,F
    DECFSZ SECOND_NUMBER_TO_MULTIPLY,F
    GOTO Multi8x8_Loop
Multi_End
    RETURN
Divide
    
    CLRF RESULT_OF_MULTIPLY
    
    MOVF SECOND_NUMBER_TO_MULTIPLY, F
    BTFSC STATUS,Z
    RETURN 
    
Divide_Loop
    MOVF SECOND_NUMBER_TO_MULTIPLY ,W
    SUBWF FIRST_NUMBER_TO_MULTIPLY,W
    BTFSS STATUS, C
    RETURN
    
    INCF RESULT_OF_MULTIPLY,F
    MOVWF FIRST_NUMBER_TO_MULTIPLY
    GOTO Divide_Loop
    

    
    END