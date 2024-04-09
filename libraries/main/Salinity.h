/*
  Anemometer.h - Library for processing the hall effect sensor data into period (then use matLab to convert to windspeed).
  Created by Team SHARA - April 2024
*/

#ifndef Salinity_h
#define Salinity_h

#include "Arduino.h"
#include "DataSource.h"
#include "Pinouts.h"

class Salinity : public DataSource
{
    Salinity(void);

    void init(void);

    public:
    int diffVol;

    private:
    double MaxVol;
    double MinVol;

};

#endif