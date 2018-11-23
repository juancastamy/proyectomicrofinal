#include "p16f887.inc"

;***************************
; TODO Step #2 - Configuration Word Setup
;***************************

; CONFIG1
; __config 0xFFD4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

;***************************
; TODO Step #3 - Variable Definitions
;***************************

GPR_VAR	UDATA
STATUS_TEMP RES 1
W_TEMP	    RES 1
DELAY1	    RES 1
DELAY2	    RES	1
CUNT1	    RES 1
CUNT2	    RES 1
CUNT3	    RES 1
CUNT4	    RES 1
VAR1	    RES 1
VAR2	    RES 1
VAR3	    RES 1
VAR4	    RES 1
	    
;***************************
; Reset Vector
;***************************

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

;***************************
; TODO Step #4 - Interrupt Service Routines
;***************************

ISR_VECT  CODE    0x0004
PUSH:
    MOVWF   W_TEMP
    SWAPF   STATUS,W
    MOVWF   STATUS_TEMP
ISR:
    BCF	    INTCON,T0IF
    MOVLW   .231
    MOVWF   TMR0
;/////////////////PWM 1/////////////////////////////////////////////////////////    
    INCF    CUNT1
    RRF	    VAR1,W
    ANDLW   B'00111111'
    SUBWF   CUNT1,W
    BTFSC   STATUS,C
    BCF	    PORTD,RD0
    BTFSS   STATUS,C
    BSF	    PORTD,RD0
;//////////////////////PWM 2////////////////////////////////////////////////////    
    INCF    CUNT2
    RRF	    VAR2,W
    ANDLW   B'00111111'
    SUBWF   CUNT2,W
    BTFSC   STATUS,C
    BCF	    PORTD,RD1
    BTFSS   STATUS,C
    BSF	    PORTD,RD1
;//////////////////////PWM 3////////////////////////////////////////////////////
    INCF    CUNT3
    RRF	    VAR3,W
    ANDLW   B'00111111'
    SUBWF   CUNT3,W
    BTFSC   STATUS,C
    BCF	    PORTD,RD2
    BTFSS   STATUS,C
    BSF	    PORTD,RD2
;//////////////////////PWM 4////////////////////////////////////////////////////    
    INCF    CUNT4
    RRF	    VAR4,W
    ANDLW   B'00111111'
    SUBWF   CUNT4,W
    BTFSC   STATUS,C
    BCF	    PORTD,RD3
    BTFSS   STATUS,C
    BSF	    PORTD,RD3
    
POP:
    SWAPF   STATUS_TEMP,W
    MOVWF   STATUS
    SWAPF   W_TEMP,F
    SWAPF   W_TEMP,W
    RETFIE			    
    
;///////////////////MAIN PROG///////////////////////////////////////////////////

MAIN_PROG CODE                      ; let linker place main program

START
    CALL    CONFIG_IO
    CALL    CONFIG_OSC
    CALL    CONFIG_INTERRUPTS
    CALL    CONFIG_ADC
    CALL    CONFIG_TMR0
    CALL    CONFIG_RX_TX
    CLRF    CUNT1
    CLRF    CUNT2
    CLRF    CUNT3
    CLRF    CUNT4
    CLRF    VAR1
    CLRF    VAR2
    CLRF    VAR3
    CLRF    VAR4
;//////////////////////////////LOOP/////////////////////////////////////////////
LOOP

    BCF	    ADCON0,CHS3
    BCF	    ADCON0,CHS2
    BCF	    ADCON0,CHS1
    BCF	    ADCON0,CHS0
    
    CALL    CHILL
    BSF	    ADCON0,GO

ADC1:
    BTFSC   ADCON0,GO
    GOTO    ADC1
    MOVF    ADRESH,W
    MOVWF   VAR1
    RRF	    VAR1,F
    BCF	    PIR1,ADIF
TX1:
    BTFSS   PIR1,TXIF
    GOTO    TX1
    MOVF    VAR1,W
    MOVWF   TXREG
RX1:
    BTFSS   PIR1,RCIF
    GOTO    RX1
    MOVF    RCREG,W
    MOVWF   VAR1
    BCF	    ADCON0,CHS3
    BCF	    ADCON0,CHS2
    BCF	    ADCON0,CHS1
    BSF	    ADCON0,CHS0
    CALL    CHILL
    BSF	    ADCON0,GO
ADC2:
    BTFSC   ADCON0,GO
    GOTO    ADC2
    MOVF    ADRESH,W
    MOVWF   VAR2
    RRF	    VAR2,F
    BCF	    PIR1,ADIF
TX2:
    BTFSS   PIR1,TXIF
    GOTO    TX2
    MOVF    VAR2,W
    MOVWF   TXREG
RX2:
    BTFSS   PIR1,RCIF
    GOTO    RX2
    MOVF    RCREG,W
    MOVWF   VAR2
    BCF	    ADCON0,CHS3
    BCF	    ADCON0,CHS2
    BSF	    ADCON0,CHS1
    BCF	    ADCON0,CHS0
    CALL    CHILL
    BSF	    ADCON0,GO
ADC3:
    BTFSC   ADCON0,GO
    GOTO    ADC3
    MOVF    ADRESH,W
    MOVWF   VAR3
    RRF	    VAR3,F
    BCF	    PIR1,ADIF
TX3:
    BTFSS   PIR1,TXIF
    GOTO    TX3
    MOVF    VAR3,W
    MOVWF   TXREG
RX3:
    BTFSS   PIR1,RCIF
    GOTO    RX3
    MOVF    RCREG,W
    MOVWF   VAR3
    BCF	    ADCON0,CHS3
    BCF	    ADCON0,CHS2
    BSF	    ADCON0,CHS1
    BSF	    ADCON0,CHS0
    CALL    CHILL
    BSF	    ADCON0,GO
ADC4:
    BTFSC   ADCON0,GO
    GOTO    ADC4
    MOVF    ADRESH,W
    MOVWF   VAR4
    RRF	    VAR4,F
    BCF	    PIR1,ADIF
TX4:
    BTFSS   PIR1,TXIF
    GOTO    TX4
    MOVF    VAR4,W
    MOVWF   TXREG
RX4:
    BTFSS   PIR1,RCIF
    GOTO    RX4
    MOVF    RCREG,W
    MOVWF   VAR4
    
    GOTO    LOOP

;///////////////////////////////CONFIGURACIONES/////////////////////////////////
CONFIG_IO
    BANKSEL PORTA
    CLRF    PORTA
    CLRF    PORTB
    CLRF    PORTC
    CLRF    PORTD
    BANKSEL TRISA
    BSF	    TRISA,0	; RA0 INPUT
    BSF	    TRISA,1	; RA1 INPUT
    BSF	    TRISA,2	; RA2 INPUT
    BSF	    TRISA,3	; RA3 INPUT
    CLRF    TRISB
    CLRF    TRISC
    CLRF    TRISD
    BANKSEL ANSEL
    BSF	    ANSEL,0	; RA0 ANALÛGICO
    BSF	    ANSEL,1	; RA1 ANALÛGICO
    BSF	    ANSEL,2	; RA2 ANALÛGICO
    BSF	    ANSEL,3	; RA3 ANALÛGICO
    CLRF    ANSELH
    RETURN

CONFIG_OSC
    BANKSEL OSCCON
    BSF	    OSCCON,IRCF2
    BSF	    OSCCON,IRCF1
    BSF	    OSCCON,IRCF0	; OSCILADOR A 8 MHZ
    RETURN

CONFIG_TMR0
    BANKSEL OPTION_REG
    BCF	    OPTION_REG,T0CS	; INTERNAL CYCLE CLOCK
    BCF	    OPTION_REG,T0SE	; INCREMENT LOW-TO-HIGH
    BCF	    OPTION_REG,PSA	; PRESCALES ASIGNADO A TMR0
    
    BCF	    OPTION_REG,PS2
    BCF	    OPTION_REG,PS1
    BSF	    OPTION_REG,PS0	; PRESCALER DE 1:4

    BANKSEL INTCON
    BSF	    INTCON,T0IE		; ENABLE TMR0 
    
    BANKSEL TMR0
    CLRF    TMR0
    MOVLW   .231
    MOVWF   TMR0
    
    RETURN
    
CONFIG_INTERRUPTS
    BANKSEL INTCON
    BSF	    INTCON,GIE	    ; ENABLE GLOBAL INTERRUPTIONS
    BCF	    INTCON,PEIE	    ; DISABLE PERIPHERAL INTERRUPTIONS
    RETURN

CONFIG_ADC
    BANKSEL ADCON0
    BSF	    ADCON0,ADCS1
    BCF	    ADCON0,ADCS0    ; FOSC/32
    BCF	    ADCON0,CHS3
    BCF	    ADCON0,CHS2
    BCF	    ADCON0,CHS1
    BCF	    ADCON0,CHS0	    ; AN0 CHANNEL
    
    BANKSEL ADCON1
    BCF	    ADCON1,ADFM	    ; LEFT JUSTIFIED
    BCF	    ADCON1,VCFG1    ; VDD INTERNO
    BCF	    ADCON1,VCFG0    ; VSS INTERNO
    
    BANKSEL PIR1
    BCF	    PIR1,ADIF
    
    BANKSEL ADCON0
    BSF	    ADCON0,ADON
    
    RETURN

    
;////////////////////////////////////SERIAL/////////////////////////////////////
CONFIG_RX_TX
    BANKSEL	TXSTA
    BCF		TXSTA, SYNC	    ; ASINCR?NO
    BSF		TXSTA, BRGH	    ; LOW SPEED
    BANKSEL	BAUDCTL
    BSF		BAUDCTL, BRG16	    ; 8 BITS BAURD RATE GENERATOR
    BANKSEL	RCSTA
    BSF		RCSTA, SPEN
    BCF		RCSTA, RX9	    ; 8BITS
    BSF		RCSTA, CREN	    ; RECEPCION
    BANKSEL	SPBRG
    MOVLW	.12
    MOVWF	SPBRG		    ; CARGAMOS EL VALOR DE BAUDRATE CALCULADO (9615 (+-16))
    CLRF	SPBRGH
    BANKSEL	TXSTA
    BSF		TXSTA, TXEN	    ; TRANSMISION

    BANKSEL	PORTD
    CLRF	PORTD
    RETURN
    
    
CHILL:   
	MOVLW .17
	MOVWF DELAY2
CONFIG1:	
	MOVLW .100
	MOVWF DELAY1
RESTA2:    
	DECFSZ	DELAY1, F
	GOTO	RESTA2
	DECFSZ	DELAY2, F
	GOTO	CONFIG1
	RETURN
    
 END