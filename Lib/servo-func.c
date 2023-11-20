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

void ambil(int lama)
{
    capit_ambil;
    delay(lama);
    lengan_atas;
    delay(lama);
}

void taruh(int lama)
{
    lengan_bawah;
    delay(lama);
    capit_lepas;
    delay(lama);
    lengan_atas;
}

void bawah_lepas()
{
    lengan_bawah;
    capit_lepas;
}

void atas_lepas()
{
    lengan_atas;
    capit_lepas;
}