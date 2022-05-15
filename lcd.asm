
_READ_temp:

;lcd.c,31 :: 		void READ_temp(void)
;lcd.c,32 :: 		{ temp = ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	CALL       _word2double+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
	MOVF       R0+2, 0
	MOVWF      _temp+2
	MOVF       R0+3, 0
	MOVWF      _temp+3
;lcd.c,33 :: 		temp = temp * 5/1023;
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
	MOVF       R0+2, 0
	MOVWF      _temp+2
	MOVF       R0+3, 0
	MOVWF      _temp+3
;lcd.c,34 :: 		temp = temp * 100;
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
	MOVF       R0+2, 0
	MOVWF      _temp+2
	MOVF       R0+3, 0
	MOVWF      _temp+3
;lcd.c,35 :: 		}
L_end_READ_temp:
	RETURN
; end of _READ_temp

_afficher_temp:

;lcd.c,37 :: 		void afficher_temp()
;lcd.c,39 :: 		READ_temp();
	CALL       _READ_temp+0
;lcd.c,40 :: 		floattostr(temp,temper);
	MOVF       _temp+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       _temp+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       _temp+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       _temp+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _temper+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;lcd.c,42 :: 		lcd_out(1,1,"TEMPERATURE=");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_lcd+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcd.c,43 :: 		lcd_out(2,10, temper);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _temper+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcd.c,44 :: 		Lcd_Chr_Cp(0xdf);
	MOVLW      223
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;lcd.c,45 :: 		Lcd_Chr_Cp('C');
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;lcd.c,46 :: 		Lcd_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;lcd.c,47 :: 		Delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_afficher_temp0:
	DECFSZ     R13+0, 1
	GOTO       L_afficher_temp0
	DECFSZ     R12+0, 1
	GOTO       L_afficher_temp0
	DECFSZ     R11+0, 1
	GOTO       L_afficher_temp0
	NOP
	NOP
;lcd.c,48 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd.c,49 :: 		}
L_end_afficher_temp:
	RETURN
; end of _afficher_temp

_afficher_nb_place:

;lcd.c,54 :: 		void afficher_nb_place(int n)
;lcd.c,55 :: 		{ EEPROM_Write(0x32, n);
	MOVLW      50
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       FARG_afficher_nb_place_n+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;lcd.c,56 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd.c,57 :: 		inttostr(EEPROM_Read(0x32),place);
	MOVLW      50
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _place+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;lcd.c,58 :: 		lcd_out(1,1,place);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _place+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcd.c,59 :: 		lcd_out(2,1,"places libre");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_lcd+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcd.c,60 :: 		Delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_afficher_nb_place1:
	DECFSZ     R13+0, 1
	GOTO       L_afficher_nb_place1
	DECFSZ     R12+0, 1
	GOTO       L_afficher_nb_place1
	DECFSZ     R11+0, 1
	GOTO       L_afficher_nb_place1
	NOP
	NOP
;lcd.c,61 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd.c,62 :: 		}
L_end_afficher_nb_place:
	RETURN
; end of _afficher_nb_place

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;lcd.c,72 :: 		void interrupt()
;lcd.c,74 :: 		if(intcon.intf==1 ) {paiement=1;
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt2
	MOVLW      1
	MOVWF      _paiement+0
	MOVLW      0
	MOVWF      _paiement+1
;lcd.c,75 :: 		}
L_interrupt2:
;lcd.c,77 :: 		if (intcon.rbif==1)
	BTFSS      INTCON+0, 0
	GOTO       L_interrupt3
;lcd.c,78 :: 		{  if(capt1==1 && n!=0)
	BTFSS      PORTB+0, 4
	GOTO       L_interrupt6
	MOVLW      0
	XORWF      _n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt50
	MOVLW      0
	XORWF      _n+0, 0
L__interrupt50:
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt6
L__interrupt44:
;lcd.c,80 :: 		flag4=1;
	MOVLW      1
	MOVWF      _flag4+0
	MOVLW      0
	MOVWF      _flag4+1
;lcd.c,81 :: 		barriere1 = 1;
	BSF        PORTB+0, 1
;lcd.c,82 :: 		delay_us(2500);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      61
	MOVWF      R13+0
L_interrupt7:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt7
	DECFSZ     R12+0, 1
	GOTO       L_interrupt7
	NOP
	NOP
;lcd.c,83 :: 		barriere1 = 0;
	BCF        PORTB+0, 1
;lcd.c,84 :: 		delay_us(17500);
	MOVLW      23
	MOVWF      R12+0
	MOVLW      185
	MOVWF      R13+0
L_interrupt8:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt8
	DECFSZ     R12+0, 1
	GOTO       L_interrupt8
;lcd.c,85 :: 		}
L_interrupt6:
;lcd.c,87 :: 		if ((capt2==1)&&(flag4==1))
	BTFSS      PORTB+0, 5
	GOTO       L_interrupt11
	MOVLW      0
	XORWF      _flag4+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt51
	MOVLW      1
	XORWF      _flag4+0, 0
L__interrupt51:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt11
L__interrupt43:
;lcd.c,88 :: 		{   if(n>0)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _n+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt52
	MOVF       _n+0, 0
	SUBLW      0
L__interrupt52:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt12
;lcd.c,89 :: 		n--;
	MOVLW      1
	SUBWF      _n+0, 1
	BTFSS      STATUS+0, 0
	DECF       _n+1, 1
L_interrupt12:
;lcd.c,91 :: 		barriere1 = 1;
	BSF        PORTB+0, 1
;lcd.c,92 :: 		delay_us(582);
	MOVLW      193
	MOVWF      R13+0
L_interrupt13:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt13
	NOP
	NOP
;lcd.c,93 :: 		barriere1 = 0;
	BCF        PORTB+0, 1
;lcd.c,94 :: 		delay_us(19418);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      54
	MOVWF      R13+0
L_interrupt14:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt14
	DECFSZ     R12+0, 1
	GOTO       L_interrupt14
	NOP
;lcd.c,96 :: 		flag5=1;
	MOVLW      1
	MOVWF      _flag5+0
	MOVLW      0
	MOVWF      _flag5+1
;lcd.c,97 :: 		flag4=0;
	CLRF       _flag4+0
	CLRF       _flag4+1
;lcd.c,99 :: 		led_rouge=1;
	BSF        PORTC+0, 1
;lcd.c,100 :: 		delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_interrupt15:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt15
	DECFSZ     R12+0, 1
	GOTO       L_interrupt15
	DECFSZ     R11+0, 1
	GOTO       L_interrupt15
	NOP
	NOP
;lcd.c,101 :: 		led_rouge=0;
	BCF        PORTC+0, 1
;lcd.c,102 :: 		}
L_interrupt11:
;lcd.c,104 :: 		if((capt3==1)&&(paiement==1)) //si paiement effectuer et capt3 detecte voiture
	BTFSS      PORTB+0, 6
	GOTO       L_interrupt18
	MOVLW      0
	XORWF      _paiement+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt53
	MOVLW      1
	XORWF      _paiement+0, 0
L__interrupt53:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt18
L__interrupt42:
;lcd.c,106 :: 		barriere2 = 1;
	BSF        PORTB+0, 2
;lcd.c,107 :: 		delay_us(2500);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      61
	MOVWF      R13+0
L_interrupt19:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt19
	DECFSZ     R12+0, 1
	GOTO       L_interrupt19
	NOP
	NOP
;lcd.c,108 :: 		barriere2 = 0;
	BCF        PORTB+0, 2
;lcd.c,109 :: 		delay_us(17500);
	MOVLW      23
	MOVWF      R12+0
	MOVLW      185
	MOVWF      R13+0
L_interrupt20:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt20
	DECFSZ     R12+0, 1
	GOTO       L_interrupt20
;lcd.c,110 :: 		flag6=1;
	MOVLW      1
	MOVWF      _flag6+0
	MOVLW      0
	MOVWF      _flag6+1
;lcd.c,112 :: 		if(capt4==0) //capt4 na pas detecte sortie
	BTFSC      PORTB+0, 7
	GOTO       L_interrupt21
;lcd.c,113 :: 		INTCON.T0IE = 1;//activer le timer tmr0
	BSF        INTCON+0, 5
L_interrupt21:
;lcd.c,114 :: 		}
L_interrupt18:
;lcd.c,116 :: 		if(capt4==1&&flag6==1)//capt4 detecte sortie
	BTFSS      PORTB+0, 7
	GOTO       L_interrupt24
	MOVLW      0
	XORWF      _flag6+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt54
	MOVLW      1
	XORWF      _flag6+0, 0
L__interrupt54:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt24
L__interrupt41:
;lcd.c,117 :: 		{   if(n<9)
	MOVLW      128
	XORWF      _n+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt55
	MOVLW      9
	SUBWF      _n+0, 0
L__interrupt55:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt25
;lcd.c,118 :: 		n++;
	INCF       _n+0, 1
	BTFSC      STATUS+0, 2
	INCF       _n+1, 1
L_interrupt25:
;lcd.c,119 :: 		intcon.intf=0 ;
	BCF        INTCON+0, 1
;lcd.c,120 :: 		paiement=0 ;
	CLRF       _paiement+0
	CLRF       _paiement+1
;lcd.c,121 :: 		intcon.rbif=0;
	BCF        INTCON+0, 0
;lcd.c,122 :: 		INTCON.T0IF = 0;   //remettre flag a zero
	BCF        INTCON+0, 2
;lcd.c,123 :: 		INTCON.T0IE = 0;//desactiver le timer tmr
	BCF        INTCON+0, 5
;lcd.c,125 :: 		barriere2 = 1;
	BSF        PORTB+0, 2
;lcd.c,126 :: 		delay_us(582);
	MOVLW      193
	MOVWF      R13+0
L_interrupt26:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt26
	NOP
	NOP
;lcd.c,127 :: 		barriere2 = 0;
	BCF        PORTB+0, 2
;lcd.c,128 :: 		delay_us(19418);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      54
	MOVWF      R13+0
L_interrupt27:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt27
	DECFSZ     R12+0, 1
	GOTO       L_interrupt27
	NOP
;lcd.c,130 :: 		led_vert=1;  //led allumee
	BSF        PORTC+0, 2
;lcd.c,131 :: 		delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_interrupt28:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt28
	DECFSZ     R12+0, 1
	GOTO       L_interrupt28
	DECFSZ     R11+0, 1
	GOTO       L_interrupt28
	NOP
	NOP
;lcd.c,132 :: 		led_vert=0;  //led etteint
	BCF        PORTC+0, 2
;lcd.c,133 :: 		flag7=1;
	MOVLW      1
	MOVWF      _flag7+0
	MOVLW      0
	MOVWF      _flag7+1
;lcd.c,134 :: 		flag6=0;
	CLRF       _flag6+0
	CLRF       _flag6+1
;lcd.c,136 :: 		}
L_interrupt24:
;lcd.c,139 :: 		intcon.rbif=0;//remettre le flag à 0 pour sortir de la fonction inteerupt
	BCF        INTCON+0, 0
;lcd.c,140 :: 		}
L_interrupt3:
;lcd.c,141 :: 		if(INTCON.T0IF == 1)
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt29
;lcd.c,142 :: 		{ nb--;
	MOVLW      1
	SUBWF      _nb+0, 1
	BTFSS      STATUS+0, 0
	DECF       _nb+1, 1
;lcd.c,143 :: 		if (nb==0)
	MOVLW      0
	XORWF      _nb+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt56
	MOVLW      0
	XORWF      _nb+0, 0
L__interrupt56:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt30
;lcd.c,144 :: 		{ Sound_Play(800,1000); //buzzer declenche
	MOVLW      32
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      232
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;lcd.c,145 :: 		nb=153;//pour avoir 10s il faut nb=153
	MOVLW      153
	MOVWF      _nb+0
	CLRF       _nb+1
;lcd.c,146 :: 		TMR0=0;
	CLRF       TMR0+0
;lcd.c,147 :: 		INTCON.T0IE = 0;   //desactiver timer
	BCF        INTCON+0, 5
;lcd.c,148 :: 		}
L_interrupt30:
;lcd.c,149 :: 		INTCON.T0IF = 0;   //remettre flag a zero
	BCF        INTCON+0, 2
;lcd.c,150 :: 		}
L_interrupt29:
;lcd.c,151 :: 		}
L_end_interrupt:
L__interrupt49:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;lcd.c,154 :: 		void main(){
;lcd.c,156 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;lcd.c,157 :: 		ADC_Init();
	CALL       _ADC_Init+0
;lcd.c,159 :: 		trisb=0xf1; //rb4--rb7 entrée
	MOVLW      241
	MOVWF      TRISB+0
;lcd.c,160 :: 		trisc.rc1=0;//ledr
	BCF        TRISC+0, 1
;lcd.c,161 :: 		trisc.rc2=0;  //ledv
	BCF        TRISC+0, 2
;lcd.c,162 :: 		trisc.rc0=0; //buzzer
	BCF        TRISC+0, 0
;lcd.c,163 :: 		trisa.ra0=1;//capt temp
	BSF        TRISA+0, 0
;lcd.c,164 :: 		trisd=0; //lcd
	CLRF       TRISD+0
;lcd.c,167 :: 		trisc.rc3=1;//btn help
	BSF        TRISC+0, 3
;lcd.c,168 :: 		trisc.rc4=0;
	BCF        TRISC+0, 4
;lcd.c,169 :: 		portc.rc4=0;
	BCF        PORTC+0, 4
;lcd.c,171 :: 		intcon.gie=1  ;
	BSF        INTCON+0, 7
;lcd.c,172 :: 		intcon.rbie=1;
	BSF        INTCON+0, 3
;lcd.c,173 :: 		intcon.INTE=1;
	BSF        INTCON+0, 4
;lcd.c,176 :: 		OPTION_REG.INTEDG = 1 ;
	BSF        OPTION_REG+0, 6
;lcd.c,177 :: 		OPTION_REG.t0cs = 0 ;
	BCF        OPTION_REG+0, 5
;lcd.c,178 :: 		OPTION_REG.psa = 0 ;
	BCF        OPTION_REG+0, 3
;lcd.c,179 :: 		OPTION_REG.ps2 = 1 ;
	BSF        OPTION_REG+0, 2
;lcd.c,180 :: 		OPTION_REG.ps1 = 1 ;
	BSF        OPTION_REG+0, 1
;lcd.c,181 :: 		OPTION_REG.ps0 = 1 ;
	BSF        OPTION_REG+0, 0
;lcd.c,182 :: 		TMR0=0;
	CLRF       TMR0+0
;lcd.c,183 :: 		nb=153;
	MOVLW      153
	MOVWF      _nb+0
	CLRF       _nb+1
;lcd.c,187 :: 		led_rouge=0;
	BCF        PORTC+0, 1
;lcd.c,188 :: 		led_vert=0;
	BCF        PORTC+0, 2
;lcd.c,190 :: 		Sound_Init(&PORTC, 0);
	MOVLW      PORTC+0
	MOVWF      FARG_Sound_Init_snd_port+0
	CLRF       FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;lcd.c,191 :: 		while(1)
L_main31:
;lcd.c,193 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd.c,194 :: 		Lcd_Out(1,6,"Bienvenue");                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_lcd+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcd.c,195 :: 		Delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main33:
	DECFSZ     R13+0, 1
	GOTO       L_main33
	DECFSZ     R12+0, 1
	GOTO       L_main33
	DECFSZ     R11+0, 1
	GOTO       L_main33
	NOP
	NOP
;lcd.c,196 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd.c,198 :: 		afficher_temp();
	CALL       _afficher_temp+0
;lcd.c,200 :: 		if (n>0)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _n+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main58
	MOVF       _n+0, 0
	SUBLW      0
L__main58:
	BTFSC      STATUS+0, 0
	GOTO       L_main34
;lcd.c,201 :: 		afficher_nb_place(n);
	MOVF       _n+0, 0
	MOVWF      FARG_afficher_nb_place_n+0
	MOVF       _n+1, 0
	MOVWF      FARG_afficher_nb_place_n+1
	CALL       _afficher_nb_place+0
L_main34:
;lcd.c,203 :: 		if(n ==0 )
	MOVLW      0
	XORWF      _n+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main59
	MOVLW      0
	XORWF      _n+0, 0
L__main59:
	BTFSS      STATUS+0, 2
	GOTO       L_main35
;lcd.c,205 :: 		lcd_out(1,1,"Parking plein");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_lcd+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcd.c,206 :: 		delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main36:
	DECFSZ     R13+0, 1
	GOTO       L_main36
	DECFSZ     R12+0, 1
	GOTO       L_main36
	DECFSZ     R11+0, 1
	GOTO       L_main36
	NOP
	NOP
;lcd.c,207 :: 		afficher_nb_place(n);
	MOVF       _n+0, 0
	MOVWF      FARG_afficher_nb_place_n+0
	MOVF       _n+1, 0
	MOVWF      FARG_afficher_nb_place_n+1
	CALL       _afficher_nb_place+0
;lcd.c,208 :: 		}
L_main35:
;lcd.c,209 :: 		if (flag7==1)
	MOVLW      0
	XORWF      _flag7+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVLW      1
	XORWF      _flag7+0, 0
L__main60:
	BTFSS      STATUS+0, 2
	GOTO       L_main37
;lcd.c,211 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd.c,212 :: 		lcd_out(1,1,"Aurevoir !!!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_lcd+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcd.c,213 :: 		delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	DECFSZ     R11+0, 1
	GOTO       L_main38
	NOP
	NOP
;lcd.c,214 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd.c,215 :: 		flag7=0;
	CLRF       _flag7+0
	CLRF       _flag7+1
;lcd.c,216 :: 		}
L_main37:
;lcd.c,218 :: 		if(help==1)
	BTFSS      PORTC+0, 3
	GOTO       L_main39
;lcd.c,219 :: 		{  Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd.c,220 :: 		lcd_out(1,1,"HELP !!!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_lcd+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;lcd.c,221 :: 		buzzer=1;
	BSF        PORTC+0, 4
;lcd.c,222 :: 		delay_ms(5000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main40:
	DECFSZ     R13+0, 1
	GOTO       L_main40
	DECFSZ     R12+0, 1
	GOTO       L_main40
	DECFSZ     R11+0, 1
	GOTO       L_main40
	NOP
;lcd.c,223 :: 		buzzer=0;
	BCF        PORTC+0, 4
;lcd.c,224 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;lcd.c,225 :: 		}
L_main39:
;lcd.c,227 :: 		}
	GOTO       L_main31
;lcd.c,228 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
