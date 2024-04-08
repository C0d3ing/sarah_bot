
/*
  Anemometer.h - Library for processing the hall effect sensor into wind speed.
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

    public:
    void ISR();
    int revolution 

};