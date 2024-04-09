/*
  Anemometer.h - Library for processing the hall effect sensor data into period (then use matLab to convert to windspeed).
  Created by Team SHARA - April 2024
*/

#ifndef Anemometer_h
#define Anemometer_h

#include <Arduino.h>
#include "DataSource.h"
#include "Pinouts.h"

class Anemometer : public DataSource
{
public:
  Anemometer(void);

  void init(void);


  void ISR(void);
  String printPeriod(void);
  int revolution;
  double period;

  // Write out
  size_t writeDataBytes(unsigned char * buffer, size_t idx);

  int lastExecutionTime = -1;

private:
  int currentTime;
  int oldTime;
  BurstADCSampler badc; 

};

#endif