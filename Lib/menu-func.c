// declare variable
int menuSelect = 0;
bool isChildSelect = false;
bool isSelect = false;

bool isTestTombol = false;

void runBot(void);
void calibration(void);
void Program_Jalan(void);
void test_motor(void);
void test_tombol(void);
void changeMenu() {
    lampu = 1;
    if(!isSelect && !isChildSelect) {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Menu");
    }

    switch (menuSelect) {
        case 0: // Run bot
            if(isSelect) runBot(); break;
            lcd_gotoxy(0, 1);
            lcd_putsf("Jalankan Robot");
            break;
        case 1: // Calibration
            if(isSelect) calibration(); break;
            lcd_gotoxy(0, 1);
            lcd_putsf("Kalibrasi Sensor");
            break;
        case 2: // Map Select
            if(isSelect || isChildSelect) map_select(); break;
            lcd_gotoxy(0, 1);
            lcd_putsf("Pilih Map");
            break;
        case 3: // Test Motor
            if(isSelect) test_motor(); break;
            lcd_gotoxy(0, 1);
            lcd_putsf("Test Motor");
            break;
        case 4: // Test tombol
            if(isSelect) test_tombol(); break;
            lcd_gotoxy(0, 1);
            lcd_putsf("Test Tombol");
            break;
    
        default:
            break;
    }
}

void runBot() {
    if(!isChildSelect) {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Run Bot");
        lcd_gotoxy(0, 1);
        lcd_putsf("Hold 1 to start");
        isChildSelect = true;
    } else if(isChildSelect) {
        lcd_clear();
        lcd_gotoxy(0, 1);
        lcd_putsf("Running...");

        Program_Jalan();
        isChildSelect = false; isSelect = false; menuSelect = 0;
        changeMenu();
    }
}

void calibration() {
    scan_garis(); 
    delay(300);
    scan_back();
    delay(100);
    hit_tengah();

    isChildSelect = false; menuSelect = 1;
    changeMenu();
}

void map_select() {
    isChildSelect = true;
}

void test_motor()
{
    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_putsf("Test Motor");

    lcd_gotoxy(0, 1);
    lcd_putsf("+100 +100");
    maju(100, 100);
    delay_ms(50);

    lcd_gotoxy(0, 1);
    lcd_putsf("-100 -100");
    maju(-100, -100);
    delay_ms(50);

    lcd_gotoxy(0, 1);
    lcd_putsf("+100 -100");
    maju(100, -100);
    delay_ms(50);

    lcd_gotoxy(0, 1);
    lcd_putsf("-100 +100");
    maju(-100, 100);

    lcd_clear();
    lcd_gotoxy(0, 0);
    
    isChildSelect = false; isSelect = false; menuSelect = 3; 
    changeMenu();
}



// test stuff
void test_tombol()
{
    lcd_gotoxy(0, 1);
    lcd_putsf("Hold 1 to exit");

    isTestTombol = true;
    while (1)
    {
        if (!isTestTombol) break;
        if ((t1 == 0) && !isDelayClick1)
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("tombol = 1     ");

            buttonhold[0] += 1;
            while ((t1 == 0) && !isDelayClick1) {
                isDelayClick1 = true;
                delay(3);
                if(buttonhold[0] > 20) {
                    isDelayClick1 = false; isSelect = false; menuSelect = 3; isTestTombol = false;
                    changeMenu(); break;
                }
                isDelayClick1 = false;
            }
        } else if (t1 == 1) {
            buttonhold[0] = 0;
            isDelayClick1 = false;
        }

        if (t2 == 0)
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("tombol = 2     ");
        }

        if (t3 == 0)
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("tombol = 3     ");
        }

        if (t4 == 0)
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("tombol = 4     ");
        }
    }
    
}

// void tes_speed()
// {
//     if (t1 == 0)
//     {
//         kecepatanka--;
//         delay_ms(10);
//     }
//     if (t2 == 0)
//     {
//         kecepatanka++;
//         delay_ms(10);
//     }
//     if (t3 == 0)
//     {
//         kecepatanki--;
//         delay_ms(10);
//     }
//     if (t4 == 0)
//     {
//         kecepatanki++;
//         delay_ms(10);
//     }

//     lcd_gotoxy(0, 0);
//     lcd_putsf("Kiri       Kanan");

//     lcd_gotoxy(0, 1);
//     sprintf(buff, "%d  ", kecepatanki);
//     lcd_puts(buff);
//     lcd_gotoxy(11, 1);
//     sprintf(buff, "%d  ", kecepatanka);
//     lcd_puts(buff);

//     maju(kecepatanki, kecepatanka);
// }

void tes_sensor()
{
    for (i = 0; i < 7; i++)
    {
        lcd_gotoxy(0, 0);
        sprintf(buff, "sensor:%d = %d  ", i, read_adc(i));
        lcd_puts(buff);
        delay_ms(100);
    }
}

void tampil_count()
{
    lcd_gotoxy(0, 0);
    sprintf(buff, " %d  ", second);
    lcd_puts(buff);
}

int bacawarna()
{
    nadc7 = read_adc(7);
    lcd_gotoxy(0, 1);
    sprintf(buff, "%d   ", nadc7);
    lcd_puts(buff);
    delay_ms(100);
    return (nadc7);
}