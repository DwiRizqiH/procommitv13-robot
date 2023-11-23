// declare variable
void runBot(void);
void calibration(void);
void Program_Jalan(void);
void test_motor(void);
void test_tombol(void);
// void map_select(int childMenuSelect);
void sens_warna(void);
// void tepuk_tangan(void);
void test_capit(void);
void changeMenu(int menuSelect, bool isSelect, int childMenuSelect) {
    lampu = 0;
    count_btn = menuSelect;
    count_child_btn = childMenuSelect;
    if(!isSelect && !isChildSelect) {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Menu");
    }

    switch (menuSelect) {
        case 0: // Calibration
            if(isSelect) { calibration(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Calibration");
            break;
        case 1: // Run bot
            if(isSelect || isChildSelect) { runBot(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Run Bot");
            break;
        case 2: // Sensor Warna
            if(isSelect) { sens_warna(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Sens Warna");
            break;
        // case 2: // Map Select
        //     if(isSelect || isChildSelect) { map_select(childMenuSelect); break; }
        //     lcd_gotoxy(0, 1);
        //     lcd_putsf("Map");
        //     break;
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
        case 5: // Tepuk tangan XD
            if(isSelect) { test_capit(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Capit");
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
        lcd_putsf("Click 2 to start");
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
    changeMenu(0, false, 0);
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
                lcd_putsf("Click 2 to select"); 
            } else if(isChildSelect) {
                mapMirror = 0;
                count_child_btn = 0;
                isChildSelect = false;
                changeMenu(0, false, 0);
            }
            
            break;
        case 1:
            if(!isChildSelect) {
                isChildSelect = true;
                lcd_clear();
                lcd_gotoxy(0, 0);
                lcd_putsf("Map Merah");
                lcd_gotoxy(0, 1);
                lcd_putsf("Click 2 to select"); 
            } else if(isChildSelect) {
                mapMirror = 1;
                count_child_btn = 0;
                isChildSelect = false;
                changeMenu(0, false, 0);
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
    setMotor(100, 100);
    delay_ms(200);

    lcd_gotoxy(0, 1);
    lcd_putsf("-100 -100");
    setMotor(-100, -100);
    delay_ms(200);

    lcd_gotoxy(0, 1);
    lcd_putsf("+100 -100");
    setMotor(100, -100);
    delay_ms(200);

    lcd_gotoxy(0, 1);
    lcd_putsf("-100 +100");
    setMotor(-100, 100);
    delay_ms(200);

    rem(100);

    lcd_clear();
    lcd_gotoxy(0, 0);
    
    isChildSelect = false;
    changeMenu(0, false, 0);
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
            changeMenu(0, false, 0);
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

void sens_warna()
{
    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_putsf("Sens Warna");

    lcd_gotoxy(0, 1);
    lcd_putsf("Warna:");

    isTestTombol = true;
    bawah_lepas();
    delay(200);
    ambil(20);
    while (1)
    {
        bacawarna();
        if (!isTestTombol) { lcd_clear(); capit_lepas; changeMenu(0, false, 0); break; }
        if ((t1 == 0))
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("Exiting...");

            isTestTombol = false;
            delay(50);
        }
    }
    
}

void test_capit()
{
    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_putsf("Test Capit");

    lcd_gotoxy(0, 1);
    lcd_putsf("Capit: > <");
    capit_ambil;
    delay(50);

    lcd_gotoxy(0, 1);
    lcd_putsf("Capit: < >");
    capit_lepas;
    delay(100);
    
    lcd_gotoxy(0, 1);
    lcd_putsf("Capit: \\/");
    lengan_bawah;
    delay(100);

    lcd_gotoxy(0, 1);
    lcd_putsf("Capit: /\\");
    lengan_atas;
    delay(100);
}

void tepuk_tangan() {

    lcd_clear();
    lcd_gotoxy(0, 1);
    lcd_putsf("Hold 1 to exit");

    lcd_gotoxy(0, 0);
    while (1)
    {
        lcd_putsf("XD");
        if(t1 == 0) break;
        capit_lepas;
        if(t1 == 0) break;
        delay(50);
        if(t1 == 0) break;
        capit_ambil;
        if(t1 == 0) break;
        delay(50);
        if(t1 == 0) break;
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

void display_map() {
    cek_sensor();
    lcd_gotoxy(7, 0);
    sprintf(buff, "%d", mapMirror);
    lcd_puts(buff);
}

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