// Line Follow
void scan(int kec)
{
    int rateError;
    int moveVal, moveLeft, moveRight;

    pilihSpeed(kec);
    sensor = sensor & 0b01111111;
    switch (sensor) //  1=kiri 8=kanan
    {               //  7......1
    case 0b00000001:
        error = -6;
        break; // DOMINAN KANAN
    case 0b00000011:
        error = -5;
        break;
    case 0b00000010:
        error = -4;
        break;
    case 0b00000110:
        error = -3;
        break;
    case 0b00000100:
        error = -2;
        break;
    case 0b00001100:
        error = -1;
        break;
    case 0b00001000:
        error = 0;
        break;
    case 0b00011000:
        error = 1;
        break;
    case 0b00010000:
        error = 2;
        break;
    case 0b00110000:
        error = 3;
        break;
    case 0b00100000:
        error = 4;
        break;
    case 0b01100000:
        error = 5;
        break;
    case 0b01000000:
        error = 6;
        break; // DOMINAN KIRI
    }
    rateError = error - lastError;
    lastError = error;

    moveVal = (int)(error * kp) + (rateError * kd);

    moveLeft = SPEED + moveVal;
    moveRight = SPEED - moveVal;

    if (moveLeft > MAX_SPEED)
    {
        moveLeft = MAX_SPEED;
    }
    if (moveLeft < MIN_SPEED)
    {
        moveLeft = MIN_SPEED;
    }

    if (moveRight > MAX_SPEED)
    {
        moveRight = MAX_SPEED;
    }
    if (moveRight < MIN_SPEED)
    {
        moveRight = MIN_SPEED;
    }

    setMotor(moveLeft, moveRight);
}

/// @brief Scan Garis Perempatan
/// @param brpkali - berapa kali scan/perempatan dilewati
/// @param kec - kecepatan motor 
void scanX(int brpkali, int kec)
{
  while (hitung < brpkali)
  {

    while ((sensor & 0b00011100) != 0b00011100)
    {
      cek_sensor();
      scan(kec);
    }

    while ((sensor & 0b00011100) == 0b00011100)
    {
      cek_sensor();
      lampu = 0;

      scan(kec);
      if ((sensor & 0b00011100) != 0b00011100)
      {
        hitung++;
        lampu = 1;
      };
    }
  };
  hitung = 0;
  // rem(lama);
}

void scanTimer(int countGoal, int kec, int lama)
{
    count = 0;
    while (count < countGoal)
    {
        cek_sensor();
        scan(kec);
        count++;
    }
    rem(lama);
}

/// @brief Scan Garis Pertigaan dari kanan garis
/// @param brpkali - berapa kali scan/pertigaan dilewati
void scanTka(int brpkali)
{
    while (hitung < brpkali)
    {
        cek_sensor();
        while ((sensor & 0b01110000) != 0b01110000) // kanan
        {
            cek_sensor();
            scan(170);
        }

        while ((sensor & 0b01110000) == 0b01110000)
        {
            cek_sensor();
            scan(170);

            if ((sensor & 0b01110000) != 0b01110000)
            {
                hitung++;
                lcd_kedip(1);
            };
        }
    };
    hitung = 0;
}
/// @brief Scan Garis Pertigaan dari kiri garis
/// @param brpkali - berapa kali scan/pertigaan dilewati
void scanTki(int brpkali)
{
    while (hitung < brpkali)
    {
        cek_sensor();
        while ((sensor & 0b00000111) != 0b00000111) // kanan
        {
            cek_sensor();
            scan(170);
        }

        while ((sensor & 0b00000111) == 0b00000111)
        {
            cek_sensor();
            scan(170);

            if ((sensor & 0b00000111) != 0b00000111)
            {
                hitung++;
                lcd_kedip(1);
            };
        }
    };
    hitung = 0;
}

void scan7ki()
{
    cek_sensor();
    while ((sensor & 0b01000000) != 0b01000000)
    {
        cek_sensor();
        scan(170);
    }
}
void scan7ka()
{
    cek_sensor();
    while ((sensor & 0b01000000) != 0b00000000)
    {
        cek_sensor();
        scan(170);
    }
}
void scan7ki2()
{
    cek_sensor();
    while (sensor == 0b00000000) // sensor !=0b00111111||0b00000011|| 0b00000001
    {
        // if (sensor ==0b00111100 ||sensor ==0b00111110 || sensor ==0b01111100 || sensor == 0b00111100 || sensor== 0b00000111 || sensor==0b00011111 ||sensor==0b00001111||sensor==0b00110011|| sensor==0b00110111|| sensor==0b00011110 || sensor==0b00001110  ) break;
        cek_sensor();
        scan(170);
    }
}