int isWarna;

void balikKiri(void);
// from Point B
void fromBtoGreen()
{
    scanX(2, 120);
    scanX(1, 100);
    // scanTimer(45, 80, 50);
    delay(15); scanKotak(1, 90, 5);

    taruh(20);

    // to Point C
    mundur(100, 100); delay(38);
    belokKiri(100, 20);
    
    scanX(2, 100);
    belokKiri(100, 20);

    scanX(2, 120);
    bawah_lepas();
    scanX(1, 90);
    scanTimer(33, 80, 50);
    // scanKotak(1, 90, 5);

    ambil(20);
}
void fromBtoYellow() 
{
    scanX(1, 100);
    belokKanan(100, 20);

    scanX(2, 120);
    scanX(1, 100);
    // scanTimer(40, 95, 50);
    delay(15); scanKotak(1, 90, 5);

    taruh(20);

    // to Point C
    mundur(100, 100); delay(38);
    belokKiri(100, 5); belokKiri(100, 20);

    scanX(1, 100);
    scanX(3, 120);
    scanX(1, 100);
    belokKiri(100, 20);

    bawah_lepas();
    scanX(1, 100);
    scanTimer(50, 90, 50);
    // scanKotak(1, 90, 5);

    ambil(20);
    
}
void fromBtoRed() {
    scanX(1, 100);
    belokKiri(100, 20);

    scanX(2, 120);
    scanX(1, 100);
    // scanTimer(37, 95, 50);
    delay(15); scanKotak(1, 90, 5);

    taruh(20);

    // to Point C
    mundur(100, 100); delay(38);
    belokKanan(100, 5); belokKanan(100, 20);

    scanX(1, 100);
    belokKanan(100, 20);

    bawah_lepas();
    scanX(1, 100);
    scanTimer(43, 95, 50);

    // scanKotak(1, 90, 5);
    ambil(20);
}


// From Point C
void fromCtoGreen() {
    scanX(1, 100);
    belokKiri(100, 20);

    scanX(1, 100);
    scanX(2, 120);
    scanX(2, 100);
    // scanTimer(37, 95, 50);
    delay(15); scanKotak(1, 90, 5);

    taruh(20);

    // to Point A
    mundur(100, 100); delay(38);
    belokKanan(100, 5); belokKanan(100, 20);

    scanX(1, 100);
    scanX(2, 100);
    belokKanan(100, 20);

    scanX(2, 120);
    scanX(1, 100);
    scanX(1, 100);

    belokKanan(90, 10);
    scanX(1, 100);
    bawah_lepas();
    scanTimer(63, 80, 50);

    // scanKotak(1, 90, 5);

    ambil(20);
}
void fromCtoYellow() {
    scanX(1, 100);
    belokKanan(100, 20);

    scanX(1, 100);
    // scanTimer(45, 95, 50);
    delay(15); scanKotak(1, 90, 5);

    taruh(20);

    // to Point A
    mundur(100, 100); delay(38);
    belokKanan(100, 20);

    scanX(2, 120);
    scanX(1, 100);
    scanX(1, 100);
    belokKanan(100, 20);

    scanX(2, 120);
    scanX(1, 100);
    bawah_lepas();
    scanX(1, 100);
    scanTimer(33, 80, 50);
    // scanKotak(1, 90, 5);

    ambil(20);
}
void fromCtoRed() {
    mundur(100, 100); delay(33);
    belokKanan(100, 5); belokKanan(100, 20);

    scanX(1, 90);
    scanX(1, 120);
    scanX(1, 100);
    // scanTimer(45, 80, 50);
    delay(15); scanKotak(1, 90, 5);

    taruh(20);

    // to Point A
    mundur(100, 100); delay(38);
    belokKanan(100, 20);

    scanX(1, 120);
    scanX(1, 100);
    bawah_lepas();
    scanX(1, 100);
    scanTimer(33, 80, 50);
    // scanKotak(1, 90, 5);

    ambil(20);
}

// from Point A
void fromAtoGreen() {
    mundur(100, 100); delay(33);
    belokKanan(100, 5); belokKanan(100, 20);

    scanX(1, 100);
    scanX(1, 120);
    scanX(1, 120);
    scanX(1, 100);
    // scanTimer(35, 95, 50);
    delay(15); scanKotak(1, 90, 5);

    taruh(20);
}
void fromAtoYellow() {
    scanX(1, 100);
    belokKiri(100, 20);

    // scanTimer(55, 95, 50);
    // scanX(1, 100);
    // rem(50);
    delay(15); scanKotak(1, 100, 5);
    taruh(20);
}
void fromAtoRed() {
    scanX(1, 120);
    scanX(1, 100);

    // scanTimer(35, 95, 50);
    delay(15); scanKotak(1, 90, 5);
    taruh(20);
}

// From Color A to Point D
void vertikalLineD(void);
void fromGreenAtoD() {
    if(positionD == 0) {
        mundur(100, 100); delay(38);
        belokKiri(100, 20);
    } else if(positionD == 1) {
        mundur(100, 100); delay(38);
        belokKanan(100, 5); belokKanan(100, 20);

        scanX(1, 100);
        scanX(1, 100);
        belokKanan(100, 20);
    } else if(positionD == 2) {
        mundur(100, 100); delay(38);
        belokKanan(100, 5); belokKanan(100, 20);

        scanX(1, 100);
        scanX(2, 120);
        scanX(1, 100);
        belokKanan(100, 20);
    } else if(positionD == 3) {
        mundur(100, 100); delay(38);
        belokKanan(100, 5); belokKanan(100, 20);

        scanX(1, 100);
        scanX(4, 120);
        scanX(1, 100);
        belokKanan(100, 20);
    }

    vertikalLineD();
}
void fromYellowAtoD() {
    if(positionD == 0) {
        mundur(100, 100); delay(38);
        belokKiri(80, 20);

        scanX(1, 100);
        scanX(3, 120);
        scanX(1, 100);
        belokKiri(100, 20);
    } else if(positionD == 1) {
        mundur(100, 100); delay(38);
        belokKiri(100, 20);

        scanX(1, 100);
        scanX(1, 120);
        scanX(1, 100);
        belokKiri(100, 20);
    } else if(positionD == 2) {
        mundur(100, 100); delay(38);
        belokKiri(100, 20);

        scanX(1, 100);
        belokKiri(100, 20);
    } else if(positionD == 3) {
        mundur(100, 100); delay(38);
        belokKanan(100, 20);

        scanX(1, 100);
        belokKanan(100, 20);
    }

    vertikalLineD();
}
void fromRedAtoD() {
    if(positionD == 0) {
        mundur(100, 100); delay(38);
        belokKanan(100, 5); belokKanan(100, 20);

        scanX(1, 100);
        scanX(4, 120);
        scanX(1, 100);
        belokKiri(100, 20);
    } else if(positionD == 1) {
        mundur(100, 100); delay(38);
        belokKanan(100, 5); belokKanan(100, 20);

        scanX(1, 100);
        scanX(2, 120);
        scanX(1, 100);
        belokKiri(100, 20);
    } else if(positionD == 2) {
        mundur(100, 100); delay(38);
        belokKiri(100, 20);

        scanX(1, 100);
        scanX(1, 100);
        belokKiri(100, 20);
    } else if(positionD == 3) {
        mundur(100, 100); delay(38);
        belokKanan(100, 20);
    }

    vertikalLineD();

}


// Jalur Vertical to Point D
void fromDto4(void);
void vertikalLineD() {
    scanX(3, 120);
    scanX(1, 100);
    bawah_lepas();
    scanX(1, 100);
    // scanTimer(25, 95, 50);

    delay(15); scanKotak(1, 90, 5);

    ambil(20);

    fromDto4();
}
// Dari D ke 4
void returnHome(void);
void fromDto4() {
    mundur(100, 100); delay(38);
    belokKanan(100, 10); belokKanan(100, 20);

    // to 4
    scanX(1, 90);
    scanX(1, 120);
    belokKiri(100, 20);

    if(positionD == 0) {
        scanX(1, 100);
    } else if(positionD == 1) {
        scanX(1, 100);
        scanX(1, 120);
        scanX(1, 120);
    } else if(positionD == 2) {
        scanX(1, 100);
        scanX(4, 120);
    } else if(positionD == 3) {
        scanX(1, 100);
        scanX(6, 120);
    }

    // scanTimer(75, 95, 50);
    delay(15); scanKotak(1, 90, 5);
    taruh(20);

    returnHome();
}

// Return Home
void returnHome() {
    mundur(100, 100); delay(20);
    belokKanan(100, 20);

    scanX(1, 100);
    scanX(3, 120);
    scanX(1, 100);
    belokKanan(100, 20);

    scanX(1, 120);
    scanX(1, 100);
    
    // scanTimer(35, 95, 50);
    delay(15); scanKotak(1, 90, 5);

    maju(100, 100); delay(30); rem(100);
    parkir();
}



/// @brief Program utama
void Program_Jalan() 
{
    // scanKotak(1, 90, 5);
    maju_delay(80, 60);
      
      // to Point B
    scanX(2, 120);
    bawah_lepas();
    scanX(1, 100);
    scanTimer(28, 80, 50);
    // scanKotak(1, 90, 5);
      
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
        fromRedAtoD();
    } else if(isWarna == kuning) {
        fromAtoYellow();
        fromYellowAtoD();
    } else if(isWarna == hijau) {
        fromAtoGreen();
        fromGreenAtoD();
    } else {
        fromAtoGreen();
        fromGreenAtoD();
    }

}

void balikKanan() {
    mundur(100, 100); delay(38);
    belokKanan(80, 0); belokKanan(80, 10);
}

void balikKiri() {
    belki(100, 5); belki(100, 20);
}

void mundurKanan() {
    mundur(100, 100); delay(38);
    belokKanan(80, 10);
}