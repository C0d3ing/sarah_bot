/*
  Thermistor.h - Library for processing the hall effect sensor data into period (then use matLab to convert to windspeed).
  Created by Team SHARA - April 2024
*/

#ifndef Thermistor_h
#define Thermistor_h

#include "Arduino.h"
#include "DataSource.h"
#include "Pinouts.h"

class Thermistor : public DataSource
{
    Thermistor(void);

    void init(void);

    public:
    int Vol;

};

#endif