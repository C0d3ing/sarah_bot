/*
  Salinity.cpp - Library for calculating salinity through conductivity
  Created by Team SHARA - April 2024
*/

#include "Salinity.h"
#include "Printer.h"
#include <Wire.h>
#include <BurstADCSampler.h>

extern Printer printer;

//Are voltages an integer?????
Salinity::Salinity(void) 
  : DataSource("Salinity","double") // from DataSource
{}

void ASalinity::init(void)
{
  pinMode(SALINITY_MAX_PIN, INPUT); 
  pinMode(SALINITY_MIN_PIN, INPUT); 
}

//Loop created Succesfully? 
void Salinity::loop()
{
    diffVol = maxVol - minVol;

}

String Salinity::printState(void)
// This function returns a string that the Printer class 
// can print to the serial monitor if desired
{
  return "Anem: " + String(diffVol);
}

//TODO: Make logger function, Finish ISR, Add calibration curve ... (more to come)