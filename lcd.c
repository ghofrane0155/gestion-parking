 // LCD module connections
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
/******************define************************/
#define capt1 portb.RB4
#define capt2 portb.RB5
#define capt3 portb.RB6
#define capt4 portb.RB7
#define bouton_paiement portb.rb0
#define barriere1 portb.RB1
#define barriere2 portb.RB2
#define led_rouge portc.rc1
#define led_vert portc.rc2
#define buzzer portc.rc4
#define help portc.rc3
/*************temperature************************/
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
/*****nb places******************/
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
/**********interruption************/
int flag5=0;
int flag4=0;
int flag6=0;
int flag7=0;
int paiement=0;
int nb;  //10s =153

int test=0;
void interrupt()
{   //si paiement effectuer
        if(intcon.intf==1 ) {paiement=1;
              }

  if (intcon.rbif==1)
   {  if(capt1==1 && n!=0)
          { /*sens du montre*/
            flag4=1;
            barriere1 = 1;
            delay_us(2500);
            barriere1 = 0;
            delay_us(17500);
          }

      if ((capt2==1)&&(flag4==1))
            {   if(n>0)
                   n--;
               /*sens inverse*/
                barriere1 = 1;
                delay_us(582);
                barriere1 = 0;
                delay_us(19418);

                flag5=1;
                flag4=0;

                led_rouge=1;
                delay_ms(1000);
                led_rouge=0;
             }

       if((capt3==1)&&(paiement==1)) //si paiement effectuer et capt3 detecte voiture
          { //moteur tourne dans sens du montre
                barriere2 = 1;
                delay_us(2500);
                barriere2 = 0;
                delay_us(17500);
                flag6=1;

                if(capt4==0) //capt4 na pas detecte sortie
                  INTCON.T0IE = 1;//activer le timer tmr0
          }

              if(capt4==1&&flag6==1)//capt4 detecte sortie
             {   if(n<9)
                  n++;
                intcon.intf=0 ;
                paiement=0 ;
                intcon.rbif=0;
                INTCON.T0IF = 0;   //remettre flag a zero
                INTCON.T0IE = 0;//desactiver le timer tmr
                //moteur tourne dans sens inverse
                  barriere2 = 1;
                  delay_us(582);
                  barriere2 = 0;
                  delay_us(19418);

                  led_vert=1;  //led allumee
                  delay_ms(1000);
                  led_vert=0;  //led etteint
                  flag7=1;
                  flag6=0;

              }


    intcon.rbif=0;//remettre le flag à 0 pour sortir de la fonction inteerupt
    }
    if(INTCON.T0IF == 1)
                 { nb--;
                   if (nb==0)
                    { Sound_Play(800,1000); //buzzer declenche
                      nb=153;//pour avoir 10s il faut nb=153
                      TMR0=0;
                      INTCON.T0IE = 0;   //desactiver timer
                    }
                    INTCON.T0IF = 0;   //remettre flag a zero
                  }
}
/***************************************/

void main(){

  Lcd_Init();
  ADC_Init();
  //config
  trisb=0xf1; //rb4--rb7 entrée
  trisc.rc1=0;//ledr
  trisc.rc2=0;  //ledv
  trisc.rc0=0; //buzzer
  trisa.ra0=1;//capt temp
  trisd=0; //lcd
  
  
  trisc.rc3=1;//btn help
  trisc.rc4=0;
  portc.rc4=0;

  intcon.gie=1  ;
  intcon.rbie=1;
  intcon.INTE=1;

  // OPTION_REG = 0b01000111;
    OPTION_REG.INTEDG = 1 ;
     OPTION_REG.t0cs = 0 ;
     OPTION_REG.psa = 0 ;
     OPTION_REG.ps2 = 1 ;
     OPTION_REG.ps1 = 1 ;
     OPTION_REG.ps0 = 1 ;
     TMR0=0;
     nb=153;


//initialisation
   led_rouge=0;
   led_vert=0;

    Sound_Init(&PORTC, 0);
    while(1)
    {
      Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
      Lcd_Out(1,6,"Bienvenue");                 // Write text in first row
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
           
        if(help==1)
          {  Lcd_Cmd(_LCD_CLEAR);
             lcd_out(1,1,"HELP !!!");
             buzzer=1;
             delay_ms(5000);
             buzzer=0;
              Lcd_Cmd(_LCD_CLEAR);
            }

     }
}