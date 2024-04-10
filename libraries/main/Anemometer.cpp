/*
  Anemometer.cpp - Library for processing the hall effect sensor into wind speed.
  Created by Team SHARA - April 2024
*/

#include "Anemometer.h"
#include "Printer.h"
#include <Wire.h>
//The following file defines Interrupt Service Routine (ISR)-- what happens when interrupt is triggered
//and provide list of possible interrupt routines.
#include <avr/interrupt.h>
#include <BurstADCSampler.h>

extern Printer printer;

Anemometer::Anemometer(void) 
  : DataSource("Anem","double") // from DataSource
{}

void Anemometer::init(void)
{
  pinMode(ANEMOMETER_PIN,INPUT_PULLUP); 
  // When the anemometer makes one revolution
  // the signal will spike to HIGH then run the ISR function

  //Initialize the starting value for time as the initial system time
  oldTime = millis();
}

void Anemometer::ISR(void)
{
  //Make TIME_INDEX public in the BurstADCSampler file
  currentTime = millis();

  period = (currentTime - oldTime);
  oldTime = currentTime;
}

String Anemometer::printPeriod(void)
// This function returns a string that the Printer class 
// can print to the serial monitor if desired
{
  return "Anem: " + String(period);
}

size_t Anemometer::writeDataBytes(unsigned char * buffer, size_t idx)
// This function writes data to the micro SD card
{
  bool * data_slot = (bool *) &buffer[idx];
  data_slot[0] = buttonState;
  return idx + sizeof(bool);
}