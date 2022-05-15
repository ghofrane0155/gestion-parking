#line 1 "C:/Users/asus/Desktop/mikroC/5-projet/lcd.c"

sbit LCD_RS at RD4_bit;
sbit LCD_EN at RD5_bit;
sbit LCD_D4 at RD0_bit;
sbit LCD_D5 at RD1_bit;
sbit LCD_D6 at RD2_bit;
sbit LCD_D7 at RD3_bit;

sbit LCD_RS_Direction at TRISD4_bit;
sbit LCD_EN_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD0_bit;
sbit LCD_D5_Direction at TRISD1_bit;
sbit LCD_D6_Direction at TRISD2_bit;
sbit LCD_D7_Direction at TRISD3_bit;
#line 28 "C:/Users/asus/Desktop/mikroC/5-projet/lcd.c"
float temp;
char temper[7];

void READ_temp(void)
{ temp = ADC_Read(0);
 temp = temp * 5/1023;
 temp = temp * 100;
}

void afficher_temp()
{
 READ_temp();
 floattostr(temp,temper);

 lcd_out(1,1,"TEMPERATURE=");
 lcd_out(2,10, temper);
 Lcd_Chr_Cp(0xdf);
 Lcd_Chr_Cp('C');
 Lcd_Chr_Cp(' ');
 Delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);
}

char place[5];
int n=9;

void afficher_nb_place(int n)
{ EEPROM_Write(0x32, n);
 Lcd_Cmd(_LCD_CLEAR);
 inttostr(EEPROM_Read(0x32),place);
 lcd_out(1,1,place);
 lcd_out(2,1,"places libre");
 Delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);
}

int flag5=0;
int flag4=0;
int flag6=0;
int flag7=0;
int paiement=0;
int nb;

int test=0;
void interrupt()
{
 if(intcon.intf==1 ) {paiement=1;
 }

 if (intcon.rbif==1)
 { if( portb.RB4 ==1 && n!=0)
 {
 flag4=1;
  portb.RB1  = 1;
 delay_us(2500);
  portb.RB1  = 0;
 delay_us(17500);
 }

 if (( portb.RB5 ==1)&&(flag4==1))
 { if(n>0)
 n--;

  portb.RB1  = 1;
 delay_us(582);
  portb.RB1  = 0;
 delay_us(19418);

 flag5=1;
 flag4=0;

  portc.rc1 =1;
 delay_ms(1000);
  portc.rc1 =0;
 }

 if(( portb.RB6 ==1)&&(paiement==1))
 {
  portb.RB2  = 1;
 delay_us(2500);
  portb.RB2  = 0;
 delay_us(17500);
 flag6=1;

 if( portb.RB7 ==0)
 INTCON.T0IE = 1;
 }

 if( portb.RB7 ==1&&flag6==1)
 { if(n<9)
 n++;
 intcon.intf=0 ;
 paiement=0 ;
 intcon.rbif=0;
 INTCON.T0IF = 0;
 INTCON.T0IE = 0;

  portb.RB2  = 1;
 delay_us(582);
  portb.RB2  = 0;
 delay_us(19418);

  portc.rc2 =1;
 delay_ms(1000);
  portc.rc2 =0;
 flag7=1;
 flag6=0;

 }


 intcon.rbif=0;
 }
 if(INTCON.T0IF == 1)
 { nb--;
 if (nb==0)
 { Sound_Play(800,1000);
 nb=153;
 TMR0=0;
 INTCON.T0IE = 0;
 }
 INTCON.T0IF = 0;
 }
}


void main(){

 Lcd_Init();
 ADC_Init();

 trisb=0xf1;
 trisc.rc1=0;
 trisc.rc2=0;
 trisc.rc0=0;
 trisa.ra0=1;
 trisd=0;


 trisc.rc3=1;
 trisc.rc4=0;
 portc.rc4=0;

 intcon.gie=1 ;
 intcon.rbie=1;
 intcon.INTE=1;


 OPTION_REG.INTEDG = 1 ;
 OPTION_REG.t0cs = 0 ;
 OPTION_REG.psa = 0 ;
 OPTION_REG.ps2 = 1 ;
 OPTION_REG.ps1 = 1 ;
 OPTION_REG.ps0 = 1 ;
 TMR0=0;
 nb=153;



  portc.rc1 =0;
  portc.rc2 =0;

 Sound_Init(&PORTC, 0);
 while(1)
 {
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,6,"Bienvenue");
 Delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);

 afficher_temp();

 if (n>0)
 afficher_nb_place(n);

 if(n ==0 )
 {
 lcd_out(1,1,"Parking plein");
 delay_ms(500);
 afficher_nb_place(n);
 }
 if (flag7==1)
 {
 Lcd_Cmd(_LCD_CLEAR);
 lcd_out(1,1,"Aurevoir !!!");
 delay_ms(500);
 Lcd_Cmd(_LCD_CLEAR);
 flag7=0;
 }

 if( portc.rc3 ==1)
 { Lcd_Cmd(_LCD_CLEAR);
 lcd_out(1,1,"HELP !!!");
  portc.rc4 =1;
 delay_ms(5000);
  portc.rc4 =0;
 Lcd_Cmd(_LCD_CLEAR);
 }

 }
}
