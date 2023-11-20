// motor
void maju(unsigned char ki, unsigned char ka)
{
    pwmka = ka;
    pwmki = ki;

    // dir kiri
    PORTD.2 = 1;
    PORTD.3 = 0;

    // dir kanan
    PORTD.6 = 0;
    PORTD.7 = 1;
}

void mundur(unsigned char ki, unsigned char ka)
{
    pwmka = ka;
    pwmki = ki;

    // dir kiri
    PORTD.2 = 0;
    PORTD.3 = 1;

    // dir kanan
    PORTD.6 = 1;
    PORTD.7 = 0;
}

void kanan(unsigned char ki, unsigned char ka)
{
    pwmka = ka;
    pwmki = ki;

    // dir kiri
    PORTD.2 = 0;
    PORTD.3 = 1;

    // dir kanan
    PORTD.6 = 0;
    PORTD.7 = 1;
}

void kiri(unsigned char ki, unsigned char ka)
{
    pwmka = ka;
    pwmki = ki;

    // dir kiri
    PORTD.2 = 1;
    PORTD.3 = 0;

    // dir kanan
    PORTD.6 = 1;
    PORTD.7 = 0;
}

void setMotor(int ki, int ka)
{
    if (ki > 0)
    {
        PORTD.2 = 1;
        PORTD.3 = 0;
    }
    else
    {
        PORTD.2 = 0;
        PORTD.3 = 1;
        ki = abs(ki);
    }
    pwmki = ki;

    if (ka > 0)
    {
        PORTD.7 = 1;
        PORTD.6 = 0;
    }
    else
    {
        PORTD.7 = 0;
        PORTD.6 = 1;
        ka = abs(ka);
    }
    pwmka = ka;
}

void rem(int nilai_rem)
{
    PORTD .4 = 1;
    PORTD .5 = 1;
    PORTD .2 = 0;
    PORTD .3 = 0;
    PORTD .6 = 0;
    PORTD .7 = 0;
    delay_ms(nilai_rem);
}

void maju_delay(int kec, int lama)
{
    maju(kec, kec);
    delay(lama);
}

void pilihSpeed(int kec)
{
    kp = kec * 0.15;
    kd = kec * 0.6;
    SPEED = kec;
    MIN_SPEED = -(kec * 0.75);
    MAX_SPEED = kec;
}

void maju_cari_garis()
{

    maju(180, 182);
    cek_sensor(); // 0b01000000)!=0b00000000)
    while ((sensor & 0b00000001) != 0b00000000)
    {
        cek_sensor();
    }
    rem(100);
}

void parkir()
{
    lampu = 0;
    while (1)
    {
        rem(100);
    }
}


#include "scan-func.c"
    // Belok garis 
void belki(int kec, int lama)
{
    cek_sensor();
    while (sen[0] || sen[1])
    {
        kiri(kec, kec);
        cek_sensor();
    }
    while (!sen[0] && !sen[1])
    {
        kiri(kec, kec);
        cek_sensor();
    }

    if (lama > 0)
    {
        rem(lama);
    }
}
void belki2()
{
    cek_sensor();
    while ((sensor & 0b00000001) != 0b00000000)
    {
        cek_sensor();
        kiri(150, 150);
        // if ((sensor & 0b00000001)==0b00000001)
        // lcd_kedip(1);
    }
}

void belka(int kec, int lama)
{
    cek_sensor();
    while (sen[5] || sen[6])
    {
        kanan(kec, kec);
        cek_sensor();
    }
    while (!sen[5] && !sen[6])
    {
        kanan(kec, kec);
        cek_sensor();
    }
    if (lama > 0)
    {
        rem(lama);
    }
}
void belkacenter()
{
    cek_sensor();
    while ((sensor & 0b00001000) != 0b00001000)
    {
        cek_sensor();
        kanan(180, 180);
        if ((sensor & 0b10000000) == 0b10000000)
            lcd_kedip(1);
    }
}

void scan_delay(int ms)
{
    k = 0;
    maju(172, 170);
    while (k < ms / 10)
    {
        delay_ms(10);
        k++;
        cek_sensor();
        scan(180);
    }
}
// belok garis mirror or no
void belokKanan(int kec, int lama_rem) {
    if(mapMirror[0] == 0) {
        belka(kec, lama_rem);
    } else {
        belki(kec, lama_rem);
    }
}
void belokKiri(int kec, int lama_rem) {
    if(mapMirror[0] == 0) {
        belki(kec, lama_rem);
    } else {
        belka(kec, lama_rem);
    }
}