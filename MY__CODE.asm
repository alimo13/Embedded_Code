
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MY__CODE.c,7 :: 		void interrupt(){
;MY__CODE.c,8 :: 		if(Manual){
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt0
;MY__CODE.c,9 :: 		Manual = 0 ;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;MY__CODE.c,10 :: 		mode = !mode;
	MOVF       _mode+0, 0
	IORWF      _mode+1, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _mode+0
	MOVWF      _mode+1
	MOVLW      0
	MOVWF      _mode+1
;MY__CODE.c,11 :: 		}
L_interrupt0:
;MY__CODE.c,12 :: 		}
L_end_interrupt:
L__interrupt44:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MY__CODE.c,13 :: 		void main() {
;MY__CODE.c,14 :: 		trisb= 0b00000011;
	MOVLW      3
	MOVWF      TRISB+0
;MY__CODE.c,15 :: 		trisc = 0 ;
	CLRF       TRISC+0
;MY__CODE.c,16 :: 		trisd = 0 ;
	CLRF       TRISD+0
;MY__CODE.c,17 :: 		portc = 0 ; portd = 0 ;
	CLRF       PORTC+0
	CLRF       PORTD+0
;MY__CODE.c,18 :: 		gie_bit = 1 ; inte_bit = 1 ;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;MY__CODE.c,20 :: 		while(1){
L_main1:
;MY__CODE.c,21 :: 		if(mode) auto_mode();
	MOVF       _mode+0, 0
	IORWF      _mode+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main3
	CALL       _auto_mode+0
	GOTO       L_main4
L_main3:
;MY__CODE.c,22 :: 		else manual_mode();
	CALL       _manual_mode+0
L_main4:
;MY__CODE.c,23 :: 		}
	GOTO       L_main1
;MY__CODE.c,24 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_auto_mode:

;MY__CODE.c,25 :: 		void auto_mode(){
;MY__CODE.c,26 :: 		portd = 0; portc = 0b1100000;
	CLRF       PORTD+0
	MOVLW      96
	MOVWF      PORTC+0
;MY__CODE.c,27 :: 		curr_mode = mode;
	MOVF       _mode+0, 0
	MOVWF      _curr_mode+0
	MOVF       _mode+1, 0
	MOVWF      _curr_mode+1
;MY__CODE.c,28 :: 		for(i=15; i>=0 ; i--){
	MOVLW      15
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
L_auto_mode5:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__auto_mode47
	MOVLW      0
	SUBWF      _i+0, 0
L__auto_mode47:
	BTFSS      STATUS+0, 0
	GOTO       L_auto_mode6
;MY__CODE.c,29 :: 		if (curr_mode!=mode) break;
	MOVF       _curr_mode+1, 0
	XORWF      _mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__auto_mode48
	MOVF       _mode+0, 0
	XORWF      _curr_mode+0, 0
L__auto_mode48:
	BTFSC      STATUS+0, 2
	GOTO       L_auto_mode8
	GOTO       L_auto_mode6
L_auto_mode8:
;MY__CODE.c,30 :: 		portd = nums[i] ;
	MOVF       _i+0, 0
	MOVWF      R0+0
	MOVF       _i+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _nums+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;MY__CODE.c,31 :: 		if(i>12) portc = 0b11010001 ;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _i+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__auto_mode49
	MOVF       _i+0, 0
	SUBLW      12
L__auto_mode49:
	BTFSC      STATUS+0, 0
	GOTO       L_auto_mode9
	MOVLW      209
	MOVWF      PORTC+0
	GOTO       L_auto_mode10
L_auto_mode9:
;MY__CODE.c,32 :: 		else  portc = 0b11100001 ;
	MOVLW      225
	MOVWF      PORTC+0
L_auto_mode10:
;MY__CODE.c,33 :: 		delay_ms(1000) ;
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_auto_mode11:
	DECFSZ     R13+0, 1
	GOTO       L_auto_mode11
	DECFSZ     R12+0, 1
	GOTO       L_auto_mode11
	DECFSZ     R11+0, 1
	GOTO       L_auto_mode11
	NOP
	NOP
;MY__CODE.c,28 :: 		for(i=15; i>=0 ; i--){
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;MY__CODE.c,34 :: 		}
	GOTO       L_auto_mode5
L_auto_mode6:
;MY__CODE.c,35 :: 		for(i=23;i>=0; i--){
	MOVLW      23
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
L_auto_mode12:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__auto_mode50
	MOVLW      0
	SUBWF      _i+0, 0
L__auto_mode50:
	BTFSS      STATUS+0, 0
	GOTO       L_auto_mode13
;MY__CODE.c,36 :: 		if(curr_mode!=mode) break;
	MOVF       _curr_mode+1, 0
	XORWF      _mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__auto_mode51
	MOVF       _mode+0, 0
	XORWF      _curr_mode+0, 0
L__auto_mode51:
	BTFSC      STATUS+0, 2
	GOTO       L_auto_mode15
	GOTO       L_auto_mode13
L_auto_mode15:
;MY__CODE.c,37 :: 		portd = nums[i];
	MOVF       _i+0, 0
	MOVWF      R0+0
	MOVF       _i+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _nums+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;MY__CODE.c,38 :: 		if (i>20) portc = 0b11001010 ;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _i+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__auto_mode52
	MOVF       _i+0, 0
	SUBLW      20
L__auto_mode52:
	BTFSC      STATUS+0, 0
	GOTO       L_auto_mode16
	MOVLW      202
	MOVWF      PORTC+0
	GOTO       L_auto_mode17
L_auto_mode16:
;MY__CODE.c,39 :: 		else portc = 0b11001100;
	MOVLW      204
	MOVWF      PORTC+0
L_auto_mode17:
;MY__CODE.c,40 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_auto_mode18:
	DECFSZ     R13+0, 1
	GOTO       L_auto_mode18
	DECFSZ     R12+0, 1
	GOTO       L_auto_mode18
	DECFSZ     R11+0, 1
	GOTO       L_auto_mode18
	NOP
	NOP
;MY__CODE.c,35 :: 		for(i=23;i>=0; i--){
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;MY__CODE.c,41 :: 		}
	GOTO       L_auto_mode12
L_auto_mode13:
;MY__CODE.c,42 :: 		}
L_end_auto_mode:
	RETURN
; end of _auto_mode

_manual_mode:

;MY__CODE.c,43 :: 		void manual_mode(){
;MY__CODE.c,44 :: 		curr_mode = mode;
	MOVF       _mode+0, 0
	MOVWF      _curr_mode+0
	MOVF       _mode+1, 0
	MOVWF      _curr_mode+1
;MY__CODE.c,45 :: 		for(i=3;i>=0;i--) {
	MOVLW      3
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
L_manual_mode19:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode54
	MOVLW      0
	SUBWF      _i+0, 0
L__manual_mode54:
	BTFSS      STATUS+0, 0
	GOTO       L_manual_mode20
;MY__CODE.c,46 :: 		portd = nums[i];
	MOVF       _i+0, 0
	MOVWF      R0+0
	MOVF       _i+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _nums+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;MY__CODE.c,47 :: 		portc = 0b01010001;
	MOVLW      81
	MOVWF      PORTC+0
;MY__CODE.c,48 :: 		if(i)delay_ms(1000);
	MOVF       _i+0, 0
	IORWF      _i+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_manual_mode22
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_manual_mode23:
	DECFSZ     R13+0, 1
	GOTO       L_manual_mode23
	DECFSZ     R12+0, 1
	GOTO       L_manual_mode23
	DECFSZ     R11+0, 1
	GOTO       L_manual_mode23
	NOP
	NOP
L_manual_mode22:
;MY__CODE.c,45 :: 		for(i=3;i>=0;i--) {
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;MY__CODE.c,49 :: 		}
	GOTO       L_manual_mode19
L_manual_mode20:
;MY__CODE.c,50 :: 		if(curr_mode!=mode) return ;
	MOVF       _curr_mode+1, 0
	XORWF      _mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode55
	MOVF       _mode+0, 0
	XORWF      _curr_mode+0, 0
L__manual_mode55:
	BTFSC      STATUS+0, 2
	GOTO       L_manual_mode24
	GOTO       L_end_manual_mode
L_manual_mode24:
;MY__CODE.c,51 :: 		while(!Manual_C && curr_mode == mode)portc = 0b00100001;
L_manual_mode25:
	BTFSC      PORTB+0, 1
	GOTO       L_manual_mode26
	MOVF       _curr_mode+1, 0
	XORWF      _mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode56
	MOVF       _mode+0, 0
	XORWF      _curr_mode+0, 0
L__manual_mode56:
	BTFSS      STATUS+0, 2
	GOTO       L_manual_mode26
L__manual_mode42:
	MOVLW      33
	MOVWF      PORTC+0
	GOTO       L_manual_mode25
L_manual_mode26:
;MY__CODE.c,52 :: 		if(curr_mode!=mode) return ;
	MOVF       _curr_mode+1, 0
	XORWF      _mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode57
	MOVF       _mode+0, 0
	XORWF      _curr_mode+0, 0
L__manual_mode57:
	BTFSC      STATUS+0, 2
	GOTO       L_manual_mode29
	GOTO       L_end_manual_mode
L_manual_mode29:
;MY__CODE.c,53 :: 		for(i=3;i>=0 ; i--){
	MOVLW      3
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
L_manual_mode30:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode58
	MOVLW      0
	SUBWF      _i+0, 0
L__manual_mode58:
	BTFSS      STATUS+0, 0
	GOTO       L_manual_mode31
;MY__CODE.c,54 :: 		portd = nums[i];
	MOVF       _i+0, 0
	MOVWF      R0+0
	MOVF       _i+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _nums+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;MY__CODE.c,55 :: 		portc = 0b10001010;
	MOVLW      138
	MOVWF      PORTC+0
;MY__CODE.c,56 :: 		if(i) delay_ms(1000);
	MOVF       _i+0, 0
	IORWF      _i+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_manual_mode33
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_manual_mode34:
	DECFSZ     R13+0, 1
	GOTO       L_manual_mode34
	DECFSZ     R12+0, 1
	GOTO       L_manual_mode34
	DECFSZ     R11+0, 1
	GOTO       L_manual_mode34
	NOP
	NOP
L_manual_mode33:
;MY__CODE.c,53 :: 		for(i=3;i>=0 ; i--){
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;MY__CODE.c,57 :: 		}
	GOTO       L_manual_mode30
L_manual_mode31:
;MY__CODE.c,58 :: 		if (curr_mode!=mode) return;
	MOVF       _curr_mode+1, 0
	XORWF      _mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode59
	MOVF       _mode+0, 0
	XORWF      _curr_mode+0, 0
L__manual_mode59:
	BTFSC      STATUS+0, 2
	GOTO       L_manual_mode35
	GOTO       L_end_manual_mode
L_manual_mode35:
;MY__CODE.c,59 :: 		while(!Manual_C && curr_mode == mode) portc = 0b00001100;
L_manual_mode36:
	BTFSC      PORTB+0, 1
	GOTO       L_manual_mode37
	MOVF       _curr_mode+1, 0
	XORWF      _mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode60
	MOVF       _mode+0, 0
	XORWF      _curr_mode+0, 0
L__manual_mode60:
	BTFSS      STATUS+0, 2
	GOTO       L_manual_mode37
L__manual_mode41:
	MOVLW      12
	MOVWF      PORTC+0
	GOTO       L_manual_mode36
L_manual_mode37:
;MY__CODE.c,60 :: 		if(curr_mode!=mode) return ;
	MOVF       _curr_mode+1, 0
	XORWF      _mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode61
	MOVF       _mode+0, 0
	XORWF      _curr_mode+0, 0
L__manual_mode61:
	BTFSC      STATUS+0, 2
	GOTO       L_manual_mode40
	GOTO       L_end_manual_mode
L_manual_mode40:
;MY__CODE.c,61 :: 		}
L_end_manual_mode:
	RETURN
; end of _manual_mode
