int salinityMin = 17;
int salinityMax = 16; 

void setup() {
  
  Serial.begin(9600);

}

void loop() {
  minV = analogRead(salinityMin);
  maxV = analogRead(salinityMin);

  diffV = maxV-minV;

  //insert calibration curve

}
