// from Point B
void fromBtoGreen() 
{
    scanX(2, 120);
    scanX(1, 80);
    scanTimer(40, 80, 50);

    taruh(20);


    // to Point C
    mundur(100, 100); delay(25);
    belokKiri(100, 10);
    
    scanX(1, 120);
    scanX(1, 100);
    belokKiri(100, 10);

    scanX(2, 120);
    bawah_lepas();
    scanX(1, 80);
    scanTimer(30, 80, 50);

    ambil(20);
}
void fromBtoYellow() 
{
    scanX(1, 80);
    belokKanan(100, 10);

    scanX(2, 120);
    scanX(1, 80);
    scanTimer(35, 95, 50);

    taruh(20);

    // to Point C
    mundur(100, 100); delay(25);
    belokKiri(100, 0); belokKiri(100, 20);

    scanX(4, 150);
    scanX(1, 80);
    belokKiri(100, 10);

    scanX(1, 80);
    bawah_lepas();
    scanTimer(45, 80, 50);

    ambil(20);
    
}
void fromBtoRed() {
    scanX(1, 80);
    belokKiri(100, 10);

    scanX(2, 120);
    scanX(1, 80);
    scanTimer(35, 95, 50);

    taruh(20);

    // to Point C
    mundur(100, 100); delay(25);
    belokKanan(100, 0); belokKanan(100, 20);
    scanX(1, 100);
    belokKanan(100, 10);

    scanX(1, 80);
    bawah_lepas();
    scanTimer(45, 95, 50);
    ambil(20);
}


// From Point C
void fromCtoGreen() {
    scanX(1, 80);
    belokKiri(100, 10);

    scanX(4, 150);
    scanX(1, 80);
    scanTimer(35, 95, 50);

    taruh(20);

    // to Point A
    mundur(100, 100); delay(25);
    belokKanan(100, 0); belokKanan(100, 20);

    scanX(1, 120);
    scanX(1, 100);
    belokKanan(100, 20);

    scanX(3, 150);
    scanX(1, 80);
    belokKanan(100, 10);

    bawah_lepas();
    scanTimer(30, 80, 50);
    ambil(20);
}
void fromCtoYellow() {
    scanX(1, 100);
    belokKanan(100, 10);

    scanX(1, 80);
    scanTimer(45, 95, 50);

    taruh(20);

    // to Point A
    mundur(100, 100); delay(25);
    belokKanan(100, 20);

    scanX(3, 150);
    scanX(1, 100);
    belokKanan(100, 10);

    scanX(2, 150);
    bawah_lepas();
    scanX(1, 80);
    scanTimer(30, 80, 50);

    ambil(20);
}
void fromCtoRed() {
    mundur(100, 100); delay(25);
    belokKiri(100, 0); belokKiri(100, 20);

    scanX(2, 120);
    scanX(1, 80);
    scanTimer(30, 80, 50);

    taruh(20);

    // to Point A
    mundur(100, 100); delay(25);
    belokKanan(100, 20);

    scanX(2, 150);
    bawah_lepas();
    scanX(1, 80);
    scanTimer(30, 80, 50);

    ambil(20);
}

// from Point A
void fromAtoGreen() {
    mundur(100, 100); delay(25);
    belokKanan(100, 0); belokKanan(100, 20);

    scanX(3, 150);
    scanX(1, 80);
    scanTimer(35, 95, 50);

    taruh(20);
}
void fromAtoYellow() {
    scanX(1, 100);
    belokKiri(100, 10);

    scanTimer(50, 95, 50);
    taruh(20);
}
void fromAtoRed() {
    scanX(2, 120);
    scanX(1, 80);
    scanTimer(35, 95, 50);
    taruh(20);
}

void from


// from Point D


void Program_Jalan() 
{
    // maju_delay(80,45);
      
    //   // to Point B
    // scanX(2, 120);
    // bawah_lepas();
    // scanX(1, 80);
    // scanTimer(30,80,50);
      
    // ambil(20);

    fromCtoYellow();
}