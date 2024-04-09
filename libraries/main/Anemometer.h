/*
  Anemometer.h - Library for processing the hall effect sensor data into period (then use matLab to convert to windspeed).
  Created by Team SHARA - April 2024
*/

#ifndef Anemometer_h
#define Anemometer_h

#include "Arduino.h"
#include "DataSource.h"
#include "Pinouts.h"

class Anemometer : public DataSource
{
    Anemometer(void);

    void init(void);

    public:
    void ISR();
    int revolution;
    double period;

    private:
    double CurrentTime;
    double oldTime;

};

#endif