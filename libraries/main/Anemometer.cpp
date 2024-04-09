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
  // the signal will spike to HIGH
  oldTime = 0;
}

void Anemometer::ISR()
{
  //Make TIME_INDEX public in the BurstADCSampler file
  currentTime = BurstADCSampler.TIME_INDEX;

  //Convert from indecies to time (Conversion from ASCSampler Library)
  period = (currentTime-oldTime)* 0.1/1000;
  oldTime = CurrentTime
}

String Anemometer::printState(void)
// This function returns a string that the Printer class 
// can print to the serial monitor if desired
{
  return "Anem: " + String(period);
}

//TODO: Make logger function, Finish ISR, Add calibration curve ... (more to come)