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
    box:1
ENDC
    
;===========TEST CASE=============    
MOVLW 6
MOVWF x

MOVLW 3
MOVWF y

MOVLW -1
MOVWF box
;=================================

    MOVLW d'0'
    SUBWF x,W
    BTFSC STATUS,C
    GOTO XPOSITIVE
    GOTO FINISH
    
XPOSITIVE
    MOVLW d'0'
    MOVF y,W
    BTFSC STATUS,C
    GOTO X_AND_Y_POSITIVE
    GOTO FINISH
    
X_AND_Y_POSITIVE
    CLRF STATUS
    MOVLW d'12'
    SUBWF x,W
    BTFSC STATUS,C
    GOTO FINISH
    GOTO X_LESS_12

X_LESS_12
    CLRF STATUS
    MOVLW d'11'
    SUBWF y,W
    BTFSC STATUS,C
    GOTO FINISH
    GOTO X_AND_Y_LESS_11
    
X_AND_Y_LESS_11	    ; X>0 && X<11 && Y>0 && Y<11
    CLRF STATUS
    MOVLW d'4'
    SUBWF x,W
    BTFSC STATUS,C
    GOTO X_GREATER_3
    GOTO X_LESS_4

X_LESS_4	   
    CLRF STATUS
    MOVLW d'2'
    SUBWF y,W
    BTFSC STATUS,C
    GOTO ELSE1
    GOTO Y_LESS_2

Y_LESS_2	; X<4 && Y<2
    MOVLW d'3'
    MOVWF box
    GOTO FINISH

ELSE1		;X<4 && !(Y<2)
    CLRF STATUS
    MOVLW d'5'
    SUBWF y,W
    BTFSC STATUS,C
    GOTO ELSE2
    GOTO Y_LESS_5

Y_LESS_5    ; X<4 && 2<Y<5
    MOVLW d'2'
    MOVWF box
    GOTO FINISH
    
ELSE2	    ; X<4 && 5<Y<11
    MOVLW d'1'
    MOVWF box
    GOTO FINISH  
    
    
    
X_GREATER_3   ; X>3
    CLRF STATUS
    MOVLW d'8'
    SUBWF x,W
    BTFSC STATUS,C
    GOTO X_GREATER_8   ; 8<X<11
    GOTO X_LESS_8    ; 3<X<8
    
X_LESS_8
    MOVLW d'6'
    SUBWF y,W
    BTFSC STATUS,C
    GOTO Y_GREATER_6_   ; 6<Y<11
    GOTO Y_LESS_6_	; 0<Y<6
    
Y_LESS_6_
     MOVLW d'5'
     MOVWF box
     GOTO FINISH  
    
Y_GREATER_6_
     MOVLW d'4'
     MOVWF box
     GOTO FINISH   
    
X_GREATER_8	; 8<X<11
    MOVLW d'3'
    SUBWF y,W
    BTFSC STATUS,C
    GOTO _Y_GREATER_3   ; 3<Y
    GOTO _Y_LESS_3	; 0<Y<3
    
_Y_GREATER_3
    MOVLW d'7'
    SUBWF y,W
    BTFSC STATUS,C
    GOTO _Y_GREATER_7   ; 7<Y
    GOTO _Y_LESS_7	; 3<Y<7
    
_Y_GREATER_7
    MOVLW d'9'
    SUBWF y,W
    BTFSC STATUS,C
    GOTO _Y_GREATER_9   ; 9<Y
    GOTO _Y_LESS_9	; 7<Y<9
    
_Y_LESS_3
     MOVLW d'9'
     MOVWF box
     GOTO FINISH

_Y_LESS_7
     MOVLW d'8'
     MOVWF box
     GOTO FINISH

_Y_LESS_9
     MOVLW d'7'
     MOVWF box
     GOTO FINISH

_Y_GREATER_9
     MOVLW d'6'
     MOVWF box
     GOTO FINISH

     
FINISH
    MOVF box,W
    MOVWF PORTD
    LOOP GOTO $ ; Infinite loop
    END
    
end