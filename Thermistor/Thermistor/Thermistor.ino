#include <Arduino.h>

int Thermistor_Pin = 14;

int reading;

void setup() {
  Serial.begin(9600);
  pinMode(Thermistor_pin, INPUT);

}

void loop() {
  Serial.print(analogRead(Thermistor_Pin));

}
