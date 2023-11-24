// sensor stuff
void konvert_logic()
{
    for(i = 0; i < 7; i++)
    {
        if(read_adc(i) > tengah[i]) {
            sen[i]=1;
        } 
        else if(read_adc(i) < tengah[i]) {
            sen[i]=0;
        }
    }        
}
void logika()
{                       
    sensor = (sen[6] * 64) + (sen[5] * 32) + (sen[4] * 16) + (sen[3] * 8) + (sen[2] * 4) + (sen[1] * 2) + (sen[0] * 1);
}   
void cek_sensor()
{
    konvert_logic();
    logika();
} 
void display_sensor()
{
    konvert_logic();
    lcd_gotoxy(9, 0);
    sprintf(buff, "%d%d%d%d%d%d%d", sen[0] , sen[1] , sen[2], sen[3], sen[4], sen[5], sen[6]); 
    lcd_puts(buff);
}  


void scan_garis()
{
    for (i = 0; i < 7; i++)
    {
        garis[i] = read_adc(i);
        lcd_gotoxy(0, 0);
        lcd_putsf("Baca Line");
        lcd_gotoxy(0, 1);
        sprintf(buff, "sensor:%d = %d  ", i, garis[i]);
        lcd_puts(buff);
        lampu = 0;
        delay_ms(10);
        lampu = 1;
    }
}

void scan_back()
{
    for (i = 0; i < 7; i++)
    {
        back[i] = read_adc(i);
        lcd_gotoxy(0, 0);
        lcd_putsf("Baca Background");
        lcd_gotoxy(0, 1);
        sprintf(buff, "sensor:%d = %d  ", i, back[i]);
        lcd_puts(buff);
        lampu = 0;
        delay_ms(10);
        lampu = 1;
    }
}

void hit_tengah()
{
    for (i = 0; i < 7; i++)
    {
        tengah[i] = (back[i] + garis[i]) / 2;
        lcd_gotoxy(0, 0);
        lcd_putsf("Center Point    ");
        lcd_gotoxy(0, 1);
        sprintf(buff, "sensor:%d --> %d  ", i, tengah[i]);
        lcd_puts(buff);
        lampu = 0;
        // delay_ms(20);
        lampu = 1;
    }
}

void cekdatasensor()
{
    for (i = 0; i < 7; i++)
    {
        lcd_gotoxy(0, 0);
        sprintf(buff, " %d  ", garis[i]);
        lcd_puts(buff);

        lcd_gotoxy(10, 0);
        sprintf(buff, " %d  ", back[i]);
        lcd_puts(buff);

        lcd_gotoxy(0, 1);
        sprintf(buff, " %d  ", tengah[i]);
        lcd_puts(buff);

        lcd_gotoxy(10, 1);
        sprintf(buff, " %d  ", read_adc(i));
        lcd_puts(buff);
        delay_ms(200);
    }
}