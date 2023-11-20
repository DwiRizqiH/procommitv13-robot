// declare variable

void runBot(void);
void calibration(void);
void Program_Jalan(void);
void test_motor(void);
void test_tombol(void);
void map_select(int childMenuSelect);
void changeMenu(int menuSelect, bool isSelect, int childMenuSelect) {
    lampu = 0;
    if(!isSelect && !isChildSelect) {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Menu");
    }

    switch (menuSelect) {
        case 0: // Run bot
            if(isSelect || isChildSelect) { runBot(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Run Bot");
            break;
        case 1: // Calibration
            if(isSelect) { calibration(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Calibration");
            break;
        case 2: // Map Select
            if(isSelect || isChildSelect) { map_select(childMenuSelect); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Map");
            break;
        case 3: // Test Motor
            if(isSelect) { test_motor(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Motor");
            break;
        case 4: // Test tombol
            if(isSelect) { test_tombol(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Button");
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
        lcd_putsf("Click 1 to start");
        isChildSelect = true;
    } else if(isChildSelect) {
        lcd_clear();
        lcd_gotoxy(0, 1);
        lcd_putsf("Running...");

        Program_Jalan();
        isChildSelect = false;
        count_child_btn = 0;
        changeMenu(0, false, 0);
    }
}

void calibration() {
    scan_garis(); 
    delay(300);
    scan_back();
    delay(100);
    hit_tengah();

    isChildSelect = false;
    changeMenu(1, false, 0);
}

void map_select(int childMenuSelect) {
    switch(childMenuSelect) {
        case 0:
            if(!isChildSelect) {
                isChildSelect = true;
                lcd_clear();
                lcd_gotoxy(0, 0);
                lcd_putsf("Map Biru");
                lcd_gotoxy(0, 1);
                lcd_putsf("Click 1 to select"); 
            } else if(isChildSelect) {
                mapMirror[0] = 0;
                count_child_btn = 0;
                isChildSelect = false;
                changeMenu(2, false, 0);
            }
            
            break;
        case 1:
            if(!isChildSelect) {
                isChildSelect = true;
                lcd_clear();
                lcd_gotoxy(0, 0);
                lcd_putsf("Map Merah");
                lcd_gotoxy(0, 1);
                lcd_putsf("Click 1 to select"); 
            } else if(isChildSelect) {
                mapMirror[0] = 1;
                count_child_btn = 0;
                isChildSelect = false;
                changeMenu(2, false, 0);
            }
            break;
        default:
            break;
    }
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
    
    isChildSelect = false;
    changeMenu(3, false, 0);
}



// test stuff
void test_tombol()
{
    lcd_gotoxy(0, 1);
    lcd_putsf("Click 1 to exit");

    isTestTombol = true;
    while (1)
    {
        if (!isTestTombol) break;
        if ((t1 == 0))
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("tombol = 1     ");

            isTestTombol = false;
            delay(50);
            changeMenu(4, false, 0);
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