/*
  Thermistor.cpp - Library for calculating salinity through conductivity
  Created by Team SHARA - April 2024
*/

#include "Salinity.h"
#include "Printer.h"
#include <Wire.h>

extern Printer printer;

//Are voltages an integer?????
Thermistor::Thermistor(void) 
  : DataSource("Thermistor","double") // from DataSource
{}

void Thermistor::init(void)
{
  pinMode(THERMISTOR_PIN, INPUT);
}

//No functions needed since we just want to read the data and send to printer and logger????

String Thermistor::printState(void)
// This function returns a string that the Printer class 
// can print to the serial monitor if desired
{
  return "Salin: " + String(Vol);
}