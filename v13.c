// Library Includes
#include <mega32.h>      
#include <delay.h>
#include <stdio.h>     
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

// Define PIN and PORT
// this is Pin Diagram (ATmega32) | https://i0.wp.com/components101.com/sites/default/files/component_pin/ATmega32-Pin-Diagram_0.png
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

// #define         servo_gulung    PORTC.5
#define         servo1          PORTC.6
#define         servo2          PORTC.7

#define         lengan_bawah    pos_servo2=240; //
#define         lengan_tengah   pos_servo2=234;
#define         lengan_atas     pos_servo2=234; //
#define         capit_lepas     pos_servo1=230;
#define         capit_ambil     pos_servo1=237;

// #define         gulung_on       pos_gulung=245;
// #define         gulung_stop     pos_gulung=255;

#define         merah   0
#define         kuning  1
#define         hijau   2


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
int hitung = 0;
unsigned int nadc7 = 0;
char buff[33];
int i, k;
// unsigned char pos_servo1, pos_servo2, pos_gulung, a, pos_led1, pos_led2;
unsigned char pos_servo1, pos_servo2, a;

int count_btn = 0;
int count_child_btn = 0;
bool isChildSelect = false;
bool isTestTombol = false;

eeprom int garis[7], back[7], tengah[7];

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

#include "a-variable.c"
#include "lib/func.c"
#include "lib/sensor-func.c"
#include "lib/motor-func.c"
// #include "lib/scan-func.c" // has already import from motor-func
#include "lib/servo-func.c"
#include "lib/warna-func.c"
#include "program.c"
#include "lib/menu-func.c"


// Timer 0 overflow interrupt service routine
interrupt[TIM0_OVF] void timer0_ovf_isr(void)
{
    TCNT0 = 0x96; // BE
    a++;

    if (a <= pos_servo1)
    {
        servo1 = 0;
    }
    else
    {
        servo1 = 1;
    }
    if (a <= pos_servo2)
    {
        servo2 = 0;
    }
    else
    {
        servo2 = 1;
    }
    // if (a <= pos_gulung)
    // {
    //     servo_gulung = 0;
    // }
    // else
    // {
    //     servo_gulung = 1;
    // }
}

// Timer 0 output compare interrupt service routine
interrupt[TIM0_COMP] void timer0_comp_isr(void)
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
    PORTA = 0x00;
    DDRA = 0x00;

    // Port B initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
    PORTB = 0x08;
    DDRB = 0Xff; // 0x08;

    // Port C initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
    // State7=T State6=T State5=T State4=T State3=P State2=P State1=P State0=P
    PORTC = 0xFF;
    DDRC = 0xF0; // C0

    // Port D initialization
    // Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
    // State7=T State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T
    PORTD = 0x03;
    DDRD = 0xFC; // 3F

    // Timer/Counter 0 initialization
    TCCR0 = 0x4A;
    TCNT0 = 0x96;
    OCR0 = 0x00;

    // Timer/Counter 1 initialization
    TCCR1A = 0xA1;
    TCCR1B = 0x09;
    TCNT1H = 0x00;
    TCNT1L = 0x00;
    ICR1H = 0x00;
    ICR1L = 0x00;
    OCR1AH = 0x00;
    OCR1AL = 0x00;
    OCR1BH = 0x00;
    OCR1BL = 0x00;

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: Timer 2 Stopped
    // Mode: Normal top=FFh
    // OC2 output: Disconnected
    ASSR = 0x00;
    TCCR2 = 0x00;
    TCNT2 = 0x00;
    OCR2 = 0x00;

    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: Off
    // INT2: Off
    MCUCR = 0x00;
    MCUCSR = 0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK = 0x01;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR = 0x80;
    SFIOR = 0x00;

    MCUCR = 0x00;
    MCUCSR = 0x00;

    // USART, UNTUK KOMUNIKASI BLUETOOTH
    UCSRA = 0x00;
    UCSRB = 0x18;
    UCSRC = 0x86;
    UBRRH = 0x00;
    UBRRL = 0x47;
    // ADC initialization
    // ADC Clock frequency: 691.200 kHz
    // ADC Voltage Reference: AVCC pin
    // ADC Auto Trigger Source: None
    // Only the 8 most significant bits of
    // the AD conversion result are used
    ADMUX = ADC_VREF_TYPE & 0xff;
    ADCSRA = 0x84;
    // ADCSRA=0xA6;
    SFIOR &= 0x1F;

    // LCD module initialization
    lcd_init(16); //
    lcd_clear();  //
    lampu = 0;    //
                  // k,b
    lcd_gotoxy(0, 0);
    lcd_putsf("     LEGION     ");
    lcd_gotoxy(0, 1);
    lcd_putsf(" MAN 4 JOMBANG ");
    delay_ms(50);
    lcd_clear();

// PROGRAM UTAMA
// Global enable interrupts
#asm("sei")
    lengan_atas;
    capit_lepas;
    // gulung_stop;

    /// mapMirror = 0 - map/lintasan bagian biru
    /// mapMirror = 1 - map/lintasan bagian merah
    if(mapMirror != 0 && mapMirror != 1) mapMirror = 0;

    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_putsf("Menu");
    lcd_gotoxy(0, 1);
    lcd_putsf("Calibration");

    while(1) {
        if(!isChildSelect) {
            display_sensor();
            bacawarna();
            display_map();
        }

        // lcd_gotoxy(0, 1);
        // sprintf(buff, "button1 = %d  ", count_btn);
        // lcd_puts(buff);

        //bacawarna();
        if((t1 == 0)) {
            // Program_Jalan();

            if(!isChildSelect) count_btn ++;
            // if(isChildSelect) count_child_btn ++;
            if(count_btn >= 6) count_btn = 0;
            delay(10);
            changeMenu(count_btn, false, count_child_btn);

            // buttonhold[0] += 1;
            // while((t1 == 0) && !isTestTombol && !isDelayClick1) {
            //     isDelayClick1 = true;
            //     delay(3);
            //     if(buttonhold[0] > 20) {
            //         isSelect = true;
            //         changeMenu();
            //     } else {
            //         isSelect = false; isChildSelect = false;
            //         changeMenu();
            //         buttonhold[0] = 0;
            //     }
            //     isDelayClick1 = false; break;
            // }
            // lcd_gotoxy(0, 0);
            // sprintf(buff, "button1 = %d  ", button1click);
        }
        if((t2 == 0)) {
            changeMenu(count_btn, true, count_child_btn);
            delay(10);
        }
            // lcd_puts(buff);
        // } else if((t1 == 1)) {
        //     buttonhold[0] = 0;
        //     isDelayClick1 = false;
        // }

            // if ((count_btn==0) && (t2==0)){
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            //     lcd_putsf("menu 1");
            // } else if((count_btn == 1) && (t2 == 0)) {
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            //     lcd_putsf("menu 2");
            // } else if((count_btn == 2) && (t2 == 0)) {
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            //     lcd_putsf("menu 3");
            // } else if((count_btn == 3) && (t2 == 0)) {
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            //     lcd_putsf("menu 4");
            // } else if((count_btn == 4) && (t2 == 0)) {
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            //     lcd_putsf("menu 5");
            // } else if((count_btn == 5) && (t2 == 0)) {
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            //     lcd_putsf("menu 6");
            // } else if((count_btn == 6) && (t2 == 0)) {
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            //     lcd_putsf("menu 7");
            // } else if((count_btn == 7) && (t2 == 0)) {
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            //     lcd_putsf("menu 8");
            // } else if((count_btn == 8) && (t2 == 0)) {
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            //     lcd_putsf("menu 9");
            // } else if((count_btn == 9) && (t2 == 0)) {
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            //     lcd_putsf("menu 10");
            // } else if((count_btn == 10) && (t2 == 0)) {
            //     lcd_clear();
            //     lcd_gotoxy(0, 0);
            // }

        // if (    (t2 == 0) 
        //         && !isTestTombol 
        //         && (!isChildSelect && menuSelect == 0) // Jika Menu di Run Bot, jangan ubah page
        //     ) {

        //         // lengan_bawah;
        //         // delay(50);
        //     // menuSelect += 1;
        //     // if(menuSelect >= 4) menuSelect = 0;
        //     // changeMenu();

        //     scan_garis(); 
        //     delay(300);
        //     scan_back();
        //     delay(100);
        //     hit_tengah();

        //     // button1click = 0;
        //     // lcd_gotoxy(0, 0);
        //     // sprintf(buff, "button1 = %d  ", button1click);
        //     // lcd_puts(buff);
        // }
    }
}
