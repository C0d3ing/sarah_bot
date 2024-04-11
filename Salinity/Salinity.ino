#include<Arduino.h>

int salinityMin = 15;
int salinityMax = 16; 

int minV;
int maxV;
int diffV;

void setup() {
  
  Serial.begin(9600);

}

void loop() {
  minV = analogRead(salinityMin);
  maxV = analogRead(salinityMin);

  diffV = maxV-minV;

  Serial.print(diffV)

  //insert calibration curve
  // or plot diffV

}
