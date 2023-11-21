int maxHijau = 215;
int maxKuning = 100;
int maxMerah = 180;

int minHijau = 190;
int minKuning = 0;
int minMerah = 120;

void bacawarna()
{
    nadc7 = read_adc(7);
    lcd_gotoxy(13, 1);
    sprintf(buff, "%d   ", nadc7);
    lcd_puts(buff);
}

int checkWarna() {
    int warna;
    nadc7 = read_adc(7);
    if(nadc7>minMerah && nadc7<maxMerah){
        warna = 0;
    }
    else if(nadc7>minKuning && nadc7<maxKuning){
        warna = 1;
    }
    else if(nadc7>minHijau && nadc7<maxHijau){
        warna = 2;
    }else{
        warna = 3;
    }
    return warna;
}