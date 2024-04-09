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
  //currentTime = grab current time some how
  period = currentTime-oldTime;
  oldTime = CurrentTime
}

String Anemometer::printState(void)
// This function returns a string that the Printer class 
// can print to the serial monitor if desired
{
  return "Anem: " + String(period);
}

//TODO: Make logger function, Finish ISR, Add calibration curve ... (more to come)