/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
? Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 9/29/2018
Author  : aak
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega32.h>      
#include <delay.h>
#include <stdio.h>     
#include <string.h>
#include <stdlib.h>


#define         lampu           PORTB.3     
#define         t1              PINC.0
#define         t2              PINC.1
#define         t3              PINC.2
#define         t4              PINC.3 
#define         s_depan         PIND.0       
#define         ledh            PORTC.4
#define         ledm            PORTC.5
#define         kipas           PORTC.6
#define         buzzer          PORTC.7
#define         pwmki           OCR1A
#define         pwmka           OCR1B
#define         servo_gulung    PORTC.5
#define         servo1          PORTC.6
#define         servo2          PORTC.7
#define         lengan_bawah    pos_servo2=240; //
#define         lengan_tengah   pos_servo2=234;
#define         lengan_atas     pos_servo2=234; //
#define         capit_lepas     pos_servo1=230;
#define         capit_ambil     pos_servo1=238;

#define         gulung_on       pos_gulung=245;
#define         gulung_stop     pos_gulung=255;


// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

#define ADC_VREF_TYPE 0x60

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

// Declare your global variables here         
int hitung=0,mulai=0;
unsigned int nadc7=0,nilai_warna=0;
char buff[33];
int i,j,k,rka=0,rki=0,k_mtr=170;  
bit x,kondisi;    
unsigned char kecepatanki=0,kecepatanka=0;    
unsigned char pos_servo1,pos_servo2,pos_gulung,a,pos_led1,pos_led2;
char simpan;
int capit=0,angkat=0,_maju=0,_mundur=0,mode_kec=0;
char arr[16],irr[16];
int push=1;

eeprom int garis[7],back[7],tengah[7];

char sen[7];
int sensor;

//-----------PID--------------//
int error = 0;
int lastError = 0;
int kp = 10;
int kd = 100;
int SPEED = 200;
int MIN_SPEED = -160;
int MAX_SPEED = 200;
//-----------------------//

int count = 0;
int second = 0;


void konvert_logic()
{
        for(i=0;i<7;i++)
        {
                if(read_adc(i)>tengah[i])
                {
                        sen[i]=1;
                } 
                
                else if(read_adc(i)<tengah[i])
                {
                        sen[i]=0;
                }
        }        
}
 
void logika()
{                       
        sensor=(sen[6]*64)+(sen[5]*32)+(sen[4]*16)+(sen[3]*8)+(sen[2]*4)+(sen[1]*2)+(sen[0]*1);
}              
void cek_sensor()
{
        konvert_logic();
        logika();
//        lcd_gotoxy(0,0);
//        lcd_putsf("CEK SENSOR  ");
//        lcd_gotoxy(0,1);
//        sprintf(buff,"%d%d%d%d%d%d%d",sen[0],sen[1],sen[2],sen[3],sen[4],sen[5],sen[6]); 
//        lcd_puts(buff);
}  

void display_sensor()
{
        konvert_logic();
        logika();
        lcd_gotoxy(0,0);
        lcd_putsf("CEK SENSOR  ");
        lcd_gotoxy(0,1);
        sprintf(buff,"%d%d%d%d%d%d%d",sen[0],sen[1],sen[2],sen[3],sen[4],sen[5],sen[6]); 
        lcd_puts(buff);
}

void lcd_kedip(int ulangi)
{  
        for(i=0;i<ulangi;i++)
        {
                lampu=0;
                delay_ms(100);
                lampu=1;
                delay_ms(100);
        }
}   

void tes_tombol()
{  

        if(t1==0)
        {
                lcd_gotoxy(0,0);   
                lcd_putsf("tombol = 1     ");            
        } 
        
        if(t2==0)
        {
                lcd_gotoxy(0,0);   
                lcd_putsf("tombol = 2     ");            
        }
        
        if(t3==0)
        {
                lcd_gotoxy(0,0);   
                lcd_putsf("tombol = 3     ");            
        }
        
        if(t4==0)
        {
                lcd_gotoxy(0,0);   
                lcd_putsf("tombol = 4     ");            
        }
        
}                    
       
void maju(unsigned char ki,unsigned char ka)
{
        pwmka=ka;
        pwmki=ki;
        
        //dir kiri
        PORTD.2=1;
        PORTD.3=0;
        
        //dir kanan
        PORTD.6=0;
        PORTD.7=1;        
} 

void mundur(unsigned char ki,unsigned char ka)
{
        pwmka=ka;
        pwmki=ki;
        
        //dir kiri
        PORTD.2=0;
        PORTD.3=1;
        
        //dir kanan
        PORTD.6=1;
        PORTD.7=0;        
}

void kanan(unsigned char ki,unsigned char ka)
{
        pwmka=ka;
        pwmki=ki;
        
        //dir kiri
        PORTD.2=0;
        PORTD.3=1;
        
        //dir kanan
        PORTD.6=0;
        PORTD.7=1;        
}

void kiri(unsigned char ki,unsigned char ka)
{
        pwmka=ka;
        pwmki=ki;
        
        //dir kiri
        PORTD.2=1;
        PORTD.3=0;
        
        //dir kanan
        PORTD.6=1;
        PORTD.7=0;        
}      

void setMotor(int ki, int ka){
    if (ki>0){
        PORTD.2=1;
        PORTD.3=0;
    }else{
        PORTD.2=0;
        PORTD.3=1;   
        ki = abs(ki);
    }
    pwmki = ki;
    
    if (ka>0){
        PORTD.7=1;
        PORTD.6=0;
    }else{
        PORTD.7=0;
        PORTD.6=1;   
        ka = abs(ka);
    }
    pwmka = ka;
}

void rem(int nilai_rem)
 {        
  PORTD.4=1;
  PORTD.5=1;
  PORTD.2=0;
  PORTD.3=0;
  PORTD.6=0;
  PORTD.7=0;
  delay_ms(nilai_rem);
 }
 
void tes_speed()
{
        if(t1==0){kecepatanka--; delay_ms(10);}  
        if(t2==0){kecepatanka++; delay_ms(10);}
        if(t3==0){kecepatanki--; delay_ms(10);}  
        if(t4==0){kecepatanki++; delay_ms(10);}    
        
        lcd_gotoxy(0,0);
        lcd_putsf("Kiri       Kanan");  
        
        lcd_gotoxy(0,1);
        sprintf(buff,"%d  ",kecepatanki); 
        lcd_puts(buff); 
        lcd_gotoxy(11,1);
        sprintf(buff,"%d  ",kecepatanka);
        lcd_puts(buff); 
        
        maju(kecepatanki,kecepatanka);     
        
}  

void tes_sensor()
{    
    //if(t1==0)
   // {
        for(i=0;i<7;i++)
        {
                lcd_gotoxy(0,0);
                sprintf(buff,"sensor:%d = %d  ",i,read_adc(i));
                lcd_puts(buff);
                delay_ms(100);
        } 
   // }
}         

void scan_garis()
{
        for(i=0;i<7;i++)
        {
                garis[i]=read_adc(i);
                lcd_gotoxy(0,0);
                lcd_putsf("Baca Line");
                lcd_gotoxy(0,1);
                sprintf(buff,"sensor:%d = %d  ",i,garis[i]); 
                lcd_puts(buff); 
                lampu=0;
                delay_ms(10); 
                lampu=1; 
                   
        }
}   

void scan_back()
{
        for(i=0;i<7;i++)
        {
                back[i]=read_adc(i); 
                lcd_gotoxy(0,0);
                lcd_putsf("Baca Background");
                lcd_gotoxy(0,1);
                sprintf(buff,"sensor:%d = %d  ",i,back[i]); 
                lcd_puts(buff);   
                lampu=0;
                delay_ms(10);  
                lampu=1;
                        
        }
}  
   

void hit_tengah()
{
        for(i=0;i<7;i++)
        {
                tengah[i]=(back[i]+garis[i])/2;   
                lcd_gotoxy(0,0);
                lcd_putsf("Center Point    ");
                lcd_gotoxy(0,1);
                sprintf(buff,"sensor:%d --> %d  ",i,tengah[i]); 
                lcd_puts(buff); 
                lampu=0;
               // delay_ms(20); 
                lampu=1;
        }
}     

 void belki(int kec, int lama)
 {      cek_sensor(); 
         while (sen[0]||sen[1])    
         { 
              kiri(kec,kec);  
              cek_sensor();    
         }
         while (!sen[0]&&!sen[1])    
         { 
              kiri(kec,kec);  
              cek_sensor();    
         }  
         
  if (lama>0){         
    rem(lama);
  }
 }
   
  void belki2()
 {      cek_sensor(); 
                 while ((sensor & 0b00000001)!=0b00000000)    
                     {cek_sensor(); 
                      kiri(150,150);
                   // if ((sensor & 0b00000001)==0b00000001)  
                   //lcd_kedip(1); 
                    
                  }

 }  
 
 
void test_motor()
 {
    maju(200,200);
    delay_ms(500);
    mundur(200,200);
    delay_ms(500);
 }
 
 void belka(int kec, int lama)
 {      cek_sensor(); 
         while (sen[5]||sen[6])    
         { 
              kanan(kec,kec);  
              cek_sensor();    
         }
         while (!sen[5]&&!sen[6])    
         { 
              kanan(kec,kec);  
              cek_sensor();    
         }
    if (lama>0){         
    rem(lama);
    }
 }
   
  void belkacenter() 
 {            cek_sensor();
                 while ((sensor & 0b00001000)!=0b00001000)    
                     {cek_sensor(); 
                     kanan(180,180);
                    if ((sensor & 0b10000000)==0b10000000)  
                   lcd_kedip(1);
                    
                  }      
 }              
 
 
void pilihSpeed(int kec){
 kp = kec*0.15;
 kd = kec*0.6;
 SPEED = kec;
 MIN_SPEED = -(kec*0.75);
 MAX_SPEED = kec;
}

void scan(int kec)
{       
        int rateError;
        int moveVal, moveLeft, moveRight;
        
        
        pilihSpeed(kec);
        sensor=sensor & 0b01111111;
        switch(sensor)          //  1=kiri 8=kanan
        {          //  7......1
                case 0b00000001: error = -6;     break;//DOMINAN KANAN
                case 0b00000011: error = -5;      break;
                case 0b00000010: error = -4;      break;
                case 0b00000110: error = -3;      break;
                case 0b00000100: error = -2;      break;
                case 0b00001100: error = -1;      break;  
                case 0b00001000: error = 0;     break;   
                case 0b00011000: error = 1;      break;
                case 0b00010000: error = 2;      break;
                case 0b00110000: error = 3;      break;
                case 0b00100000: error = 4;      break;
                case 0b01100000: error = 5;      break;
                case 0b01000000: error = 6;      break;// DOMINAN KIRI  
        }
    rateError = error - lastError;
    lastError = error;
    
    moveVal = (int)(error*kp) + (rateError*kd);
    
    moveLeft = SPEED + moveVal;
    moveRight = SPEED - moveVal;
    
    if(moveLeft > MAX_SPEED){
        moveLeft = MAX_SPEED;
    }
    if(moveLeft < MIN_SPEED){
        moveLeft = MIN_SPEED;
    }                       
    
    
    if(moveRight > MAX_SPEED){
        moveRight = MAX_SPEED;
    }
    if(moveRight < MIN_SPEED){
        moveRight = MIN_SPEED;
    }            
    
    setMotor(moveLeft, moveRight);
}

void scan_delay(int ms)
 {
    k = 0;
    maju(172,170);
    while(k<ms/10){
            delay_ms(10);
            k++; 
            cek_sensor();
            scan(180);
    }
    
 }                                                                                                                                                                                                                                                  


void scan7ki()
{    cek_sensor();  
     while ((sensor & 0b01000000)!=0b01000000) 
         { cek_sensor();   scan(170); }
                     
}   
void scan7ka()
{    cek_sensor();  
     while ((sensor & 0b01000000)!=0b00000000) 
         { cek_sensor();   scan(170); } 
                      
}

void scan7ki2()
{             cek_sensor(); 
                 while (sensor ==0b00000000)    //sensor !=0b00111111||0b00000011|| 0b00000001
                     {
                    // if (sensor ==0b00111100 ||sensor ==0b00111110 || sensor ==0b01111100 || sensor == 0b00111100 || sensor== 0b00000111 || sensor==0b00011111 ||sensor==0b00001111||sensor==0b00110011|| sensor==0b00110111|| sensor==0b00011110 || sensor==0b00001110  ) break;
                    cek_sensor();   scan(170);  } 
                      
}

void cekdatasensor()
{      
        for(i=0;i<7;i++)
        {
                lcd_gotoxy(0,0);
                sprintf(buff," %d  ",garis[i]);  
                lcd_puts(buff);   
                
                lcd_gotoxy(10,0);
                sprintf(buff," %d  ",back[i]);  
                lcd_puts(buff);    
                
                lcd_gotoxy(0,1);
                sprintf(buff," %d  ",tengah[i]);  
                lcd_puts(buff); 
                
                lcd_gotoxy(10,1);
                sprintf(buff," %d  ",read_adc(i));  
                lcd_puts(buff);       
                delay_ms(200); 
        }
}
void delay(int ms) {
    delay_ms(ms);
} 


 
 
 void parkir()
 {  lampu=0; while(1){rem(100);} }
 
 void maju_cari_garis(){
               
       maju(180,182);
       cek_sensor();  // 0b01000000)!=0b00000000)
       while((sensor & 0b00000001)!=0b00000000) {
          cek_sensor();                     
       }
        rem(100);    
 } 

void scanX(int brpkali, int kec)
{
  while (hitung < brpkali)
  {

    while ((sensor & 0b00011100) != 0b00011100)
    {
      cek_sensor();
      scan(kec);
    }

    while ((sensor & 0b00011100) == 0b00011100)
    {
      cek_sensor();
      lampu = 0;

      scan(kec);
      if ((sensor & 0b00011100) != 0b00011100)
      {
        hitung++;
        lampu = 1;
      };
    }
  };
  hitung = 0;
  // rem(lama);
}
 
void scanTimer(int countGoal, int kec, int lama){
    count = 0;
    while(count < countGoal){
        cek_sensor();
        scan(kec);
        count++;
    }
    rem(lama);
}

 void scanTka(int brpkali)
 {
  while (hitung<brpkali) {
                  cek_sensor();         
                 while ((sensor & 0b01110000)!=0b01110000)   //kanan 
                 {cek_sensor(); scan(170);
                 
                 }
                           
                while ((sensor & 0b01110000)==0b01110000)    
                {cek_sensor();  scan(170);
                   
                    if ((sensor & 0b01110000)!=0b01110000) { 
                        hitung++;
                        lcd_kedip(1);
                        }; 
                }   
         };   hitung=0;
 }      
  void scanTki(int brpkali)
 {
  while (hitung<brpkali) {
                  cek_sensor();         
                 while ((sensor & 0b00000111)!=0b00000111)   //kanan 
                 {cek_sensor(); scan(170);
                 
                 }
                           
                while ((sensor & 0b00000111)==0b00000111)    
                {cek_sensor();  scan(170);
                   
                    if ((sensor & 0b00000111)!=0b00000111) { 
                        hitung++;
                        lcd_kedip(1);
                        }; 
                }   
         };   hitung=0;
 }    
 

 
void android()
{
  while(1){
   simpan=getchar();
    if(simpan=='k'){
        if(mode_kec==0){mode_kec=1;k_mtr=190; }
        else if (mode_kec==1){mode_kec=0; k_mtr=160;}   
    }  
    else if(simpan=='b') //maju
    {
        if(_maju==0){_maju=1; maju(k_mtr,k_mtr);}
        else if(_maju==1){_maju=0;rem(100);}
    }
     else if(simpan=='t') //majuCEPET
    {
        if(_maju==0){_maju=1; maju(190,192);}
        else if(_maju==1){_maju=0;rem(100);}
    }
    else if(simpan=='d')   //mundur
    {
        if(_mundur==0){_mundur=1;mundur(k_mtr,k_mtr);}
        else if(_mundur==1){_mundur=0;rem(100);}
    }
    else if(simpan=='a'){kiri(k_mtr-25,k_mtr-25);}
    else if(simpan=='c'){kanan(k_mtr-25,k_mtr-25);}
    else if(simpan=='x'){rem(100);}
    else if(simpan=='f')
    {
        if(capit==0){capit=1; capit_ambil;}      
        else if(capit==1){capit=0; capit_lepas;} 
    }
    else if(simpan=='h')
    {
        if(angkat==0){angkat=1;lengan_atas;}
        else if(angkat==1){angkat=0; lengan_bawah;} 
    }
            
    else if(simpan=='o') //GOTO ATO MODE
    {
        break;
    } 
  }
} 

void griper()
{
    capit_lepas;
    lengan_tengah;
    delay_ms(5000);
    lengan_bawah;
    delay_ms(5000);
    capit_ambil;
    delay_ms(7000);
    lengan_atas;
    delay_ms(5000);
    lengan_bawah;
    delay_ms(5000);
    capit_lepas;
} 

void ambil(int lama){
   capit_ambil; delay(lama);
   lengan_atas; delay(lama);             
}

void taruh(int lama){
    lengan_bawah; delay(lama);
    capit_lepas; delay(lama);
    lengan_atas;
}

void bawah_lepas(){
    lengan_bawah; 
    capit_lepas;
}

void atas_lepas(){
    lengan_atas; 
    capit_lepas;
}

void maju_delay(int kec, int lama){
 maju(kec,kec);
 delay(lama);
}

  // Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
 TCNT0=0x96; //BE
 a++;
 
       if    (a<=pos_servo1)      {servo1=0;}      
       else                      {servo1=1; }
       if    (a<=pos_servo2)      {servo2=0;}      
       else                      {servo2=1; }   
       if    (a<=pos_gulung)     {servo_gulung=0;}      
       else                      {servo_gulung=1; }                

}

void tampil_count(){
        lcd_gotoxy(0,0);
        sprintf(buff," %d  ",second);  
        lcd_puts(buff);
}

int bacawarna()
{
    nadc7=read_adc(7);
    lcd_gotoxy(0,1);
    sprintf(buff,"%d   ",nadc7); 
    lcd_puts(buff);
    delay_ms(100);  
    return(nadc7);
}
// Timer 0 output compare interrupt service routine
interrupt [TIM0_COMP] void timer0_comp_isr(void)
{
// Place your code here
}
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x08;
DDRB=0Xff;//0x08;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=P State2=P State1=P State0=P 
PORTC=0xFF;
DDRC=0xF0; //C0

// Port D initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x03;
DDRD=0xFC; //3F

// Timer/Counter 0 initialization    
TCCR0=0x4A;
TCNT0=0x96;
OCR0=0x00;

// Timer/Counter 1 initialization
TCCR1A=0xA1;
TCCR1B=0x09;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x03;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;



MCUCR=0x00;
MCUCSR=0x00;

//USART, UNTUK KOMUNIKASI BLUETOOTH
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x47;
// ADC initialization
// ADC Clock frequency: 691.200 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;
//ADCSRA=0xA6;
SFIOR&=0x1F;

// LCD module initialization
lcd_init(16); //      
lcd_clear();//
lampu=0;    //
         //k,b
lcd_gotoxy(0,0);
lcd_putsf("AMADEUS TEST");
lcd_gotoxy(0,1);
lcd_putsf("MAN 4 JOMBANG");
delay_ms(100);
lcd_clear();


// PROGRAM UTAMA
// Global enable interrupts
#asm("sei")
lengan_atas;
capit_lepas;
gulung_stop;

while (1){ 
  while(1){
    display_sensor();
   // tampil_count(); 
     
     
     if(t1==0){    
      // to Arena
      maju_delay(80,45);
      
    //   // to Point B
    //   scanX(2, 120);
    //   bawah_lepas();
    //   scanX(1, 80);
    //   scanTimer(30,80,50);
      
    //   ambil(20);
      
    //   // to (2-up)
      scanX(2, 120);
      scanX(1, 80);
      scanTimer(40,80,50);
      taruh(20);
      
      mundur(100, 100); delay(25);
      belka(100, 10);
      
      bawah_lepas();
          
      // to Point A
      scanX(1, 80);
      scanTimer(35,95,50);
      
      ambil(20);
      
    //   // to (1-right)
    //   scanX(2, 100);
    //   delay(20); rem(30);
    //   taruh(20);
      
    //   mundur(100, 100); delay(25);
    //   belka(100, 0); belka(100, 10);
      
    //   // to Point C
    //   scanX(4, 120);
    //   scanX(1, 80);
    //   belki(100, 10);
      
    //   scanX(1, 120);
    //   bawah_lepas();
    //   scanX(2, 100);
    //   scanTimer(25,80,50);
      
    //   ambil(20);
    //   scanX(1, 80);
      
    //   // to (3-left)
    //   belka(100, 10);
    //   scanX(1, 100);
    //   scanTimer(40,100,50);
    //   taruh(20);
      
    //    // to Point D-4
    //    mundur(100, 100); delay(25);
    //    belka(100, 0); belka(100, 10);
    //    scanX(5, 120);
    //    scanX(1, 100); rem(30);
       
    //    belka(100, 10);
    //    bawah_lepas();
    //    scanX(1, 80);
    //    scanTimer(45,80,50);
      
    //    ambil(20);
       
    //    // to 4
    //    belka(100, 0); belka(80, 20);
    //    scanX(2, 100);
    //    belki(100, 30);
       
    //    scanX(7, 150);
    //    scanTimer(120,80,50);
    //    taruh(20);
       
      
     
//      scanX(1, 100, 100);
//      belka(100, 100);
//      
//      bawah_lepas();
//      
//      scanX(1, 100, 0);
//      maju_delay(80, 45); rem(100);
//      
//      ambil(20);
      
      }
     if(t2==0){            
         scan_garis(); 
         delay(300);
         scan_back();
         delay(100);
         hit_tengah();
         
     }
          
  } 
 }     
}
