void delay(int ms)
{
    delay_ms(ms);
}

void lcd_kedip(int ulangi)
{  
    for(i = 0; i < ulangi; i++)
    {
        lampu=0;
        delay_ms(100);
        lampu=1;
        delay_ms(100);
    }
} 