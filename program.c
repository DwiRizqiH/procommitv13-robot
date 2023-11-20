int isWarna;

// from Point B
void fromBtoGreen() 
{
    scanX(2, 120);
    scanX(1, 80);
    scanTimer(40, 80, 50);

    taruh(20);


    // to Point C
    mundur(100, 100); delay(10);
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
    mundur(100, 100); delay(10);
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
    mundur(100, 100); delay(20);
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
    mundur(100, 100); delay(10);
    belokKanan(100, 0); belokKanan(100, 20);

    scanX(2, 100);
    belokKanan(100, 20);

    scanX(3, 150);
    scanX(1, 80);
    bawah_lepas();
    belokKanan(100, 10);

    scanTimer(40, 80, 50);
    ambil(20);
}
void fromCtoYellow() {
    scanX(1, 100);
    belokKanan(100, 10);

    scanX(1, 80);
    scanTimer(45, 95, 50);

    taruh(20);

    // to Point A
    mundur(100, 100); delay(10);
    belokKanan(100, 20);

    scanX(3, 150);
    scanX(1, 100);
    belokKanan(100, 10);

    scanX(2, 150);
    bawah_lepas();
    scanX(1, 80);
    scanTimer(40, 80, 50);

    ambil(20);
}
void fromCtoRed() {
    mundur(100, 100); delay(10);
    belokKiri(100, 0); belokKiri(100, 20);

    scanX(2, 120);
    scanX(1, 80);
    scanTimer(30, 80, 50);

    taruh(20);

    // to Point A
    mundur(100, 100); delay(10);
    belokKanan(100, 20);

    scanX(2, 150);
    bawah_lepas();
    scanX(1, 80);
    scanTimer(30, 80, 50);

    ambil(20);
}

// from Point A
void fromAtoGreen() {
    mundur(100, 100); delay(10);
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

// From Color A to Point D
void vertikalLineD(void);
void fromGreenAtoD() {
    if(positionD == 0) {
        mundur(100, 100); delay(10);
        belokKiri(100, 10);
    } else if(positionD == 1) {
        mundur(100, 100); delay(10);
        belokKanan(100, 0); belokKanan(100, 20);

        scanX(1, 100);
        scanX(1, 120);
        belokKanan(100, 10);
    } else if(positionD == 2) {
        mundur(100, 100); delay(10);
        belokKanan(100, 0); belokKanan(100, 20);

        scanX(1, 100);
        scanX(2, 150);
        scanX(1, 120);
        belokKanan(100, 10);
    } else if(positionD == 3) {
        mundur(100, 100); delay(10);
        belokKanan(100, 0); belokKanan(100, 20);

        scanX(1, 100);
        scanX(4, 150);
        scanX(1, 120);
        belokKanan(100, 10);
    }

    vertikalLineD();
}


// Jalur Vertical to Point D
void fromDto4(void);
void vertikalLineD() {
    scanX(4, 150);
    bawah_lepas();
    scanX(1, 80);
    scanTimer(35, 95, 50);

    ambil(20);

    fromDto4();
}
// Dari D ke 4
void returnHome(void);
void fromDto4() {
    mundur(100, 100); delay(10);
    belokKanan(100, 0); belokKanan(100, 20);

    // to 4
    scanX(1, 90);
    scanX(1, 120);
    belokKiri(100, 10);

    if(positionD == 0) {
        scanX(1, 120);
    } else if(positionD == 1) {
        scanX(3, 120);
    } else if(positionD == 2) {
        scanX(5, 120);
    } else if(positionD == 3) {
        scanX(7, 120);
    }

    scanTka(1);
    taruh(20);

    returnHome();
}

// Return Home
void returnHome() {
    mundur(100, 100); delay(10);
    belokKanan(100, 0); belokKanan(100, 20);

    scanX(1, 100);
    scanX(3, 150);
    scanX(1, 120);
    belokKanan(100, 10);

    scanX(2, 150);
    scanTka(1);

    maju_delay(80, 45);
    parkir();
}



/// @brief Program utama
void Program_Jalan() 
{
    maju_delay(80,45);
      
      // to Point B
    scanX(2, 120);
    bawah_lepas();
    scanX(1, 80);
    scanTimer(35, 80, 50);
      
    ambil(20);
    delay(50);

    isWarna = checkWarna();
    if(isWarna == merah) {
        fromBtoRed();
    } else if(isWarna == kuning) {
        fromBtoYellow();
    } else if(isWarna == hijau) {
        fromBtoGreen();
    } else {
        fromBtoGreen();
    }

    delay(50);
    // to Point C
    isWarna = checkWarna();
    if(isWarna == merah) {
        fromCtoRed();
    } else if(isWarna == kuning) {
        fromCtoYellow();
    } else if(isWarna == hijau) {
        fromCtoGreen();
    } else {
        fromCtoGreen();
    }

    delay(50);
    // to Point A
    isWarna = checkWarna();
    if(isWarna == merah) {
        fromAtoRed();
    } else if(isWarna == kuning) {
        fromAtoYellow();
    } else if(isWarna == hijau) {
        fromAtoGreen();
    } else {
        fromAtoGreen();
    }
}