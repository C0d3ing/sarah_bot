/********
Default E80 Code
Current Author:
    Wilson Ives (wives@g.hmc.edu) '20 (contributed in 2018)
Previous Contributors:
    Christopher McElroy (cmcelroy@g.hmc.edu) '19 (contributed in 2017)  
    Josephine Wong (jowong@hmc.edu) '18 (contributed in 2016)
    Apoorva Sharma (asharma@hmc.edu) '17 (contributed in 2016)                    
*/

/* Libraries */

// general
#include <Arduino.h>
#include <Wire.h>
#include <Pinouts.h>

// E80-specific
#include <SensorIMU.h>
#include <MotorDriver.h>
#include <Logger.h>
#include <Printer.h>


/* Global Variables */

// period in ms of logger and printer
#define LOOP_PERIOD 100

// Motors
MotorDriver motorDriver;

// IMU
SensorIMU imu;

// Logger
Logger logger;
bool keepLogging = true;

// Printer
Printer printer;

// loop start recorder
int loopStartTime;

void setup() {
  printer.init();

  /* Initialize the Logger */
  logger.include(&imu);
  logger.include(&motorDriver);
  logger.init();

  /* Initialise the sensors */
  imu.init();

  /* Initialize motor pins */
  motorDriver.init();

  /* Keep track of time */
  printer.printMessage("Starting main loop",10);
  loopStartTime = millis();
}


void loop() {

  int currentTime = millis() - loopStartTime;
  
  ///////////  Don't change code above here! ////////////////////
  // write code here to make the robot fire its motors in the sequence specified in the lab manual 
  // the currentTime variable contains the number of ms since the robot was turned on 
  // The motorDriver.drive function takes in 3 inputs arguments motorA_power, motorB_power, motorC_power: 
  //void motorDriver.drive(int motorA_power,int motorB_power,int motorC_power); 
  // the value of motorX_power can range from -255 to 255, and sets the PWM applied to the motor 

  //initializing variables for power control
  float duty_cycle = 1;
  float ft;
  float robot_mass;
  float accl;
  float t1;
  float t2;

  //calculations for resulting ms time
  ft = -0.6971*duty_cycle + 0.0593;
  robot_mass = 3.237;
  accl = abs(ft/robot_mass);
  t1 = int(sqrt(0.762/(0.5*accl)));
  t2 = int(sqrt(1.82/(0.5*accl)));
  
  //motor power values
  //motorA = x-dir, motorB = y-dir, motorC = z-dir
  float motorA_power = duty_cycle*255;
  float motorB_power = duty_cycle*255;
  float motorC_power = duty_cycle*255;

  int loading_time = 50000;
  //move 2.5' -z
  if (currentTime > 4000+loading_time && currentTime <14000+loading_time) {
    motorDriver.drive(0,0,motorC_power);
  } else {
    motorDriver.drive(0,0,0);
  }
  //move 6' -x
  if (currentTime > 15000+loading_time && currentTime <35000+loading_time) {
    motorDriver.drive(motorA_power,motorB_power,0);
  } else {
    motorDriver.drive(0,0,0);
  }
  //move 2.5 +z
  if (currentTime > 36000+loading_time && currentTime <46000+loading_time) {
    motorDriver.drive(0,0,-motorC_power);
  } else {
    motorDriver.drive(0,0,0);
  }

  // // The following example will turn on motor B for four seconds between seconds 4 and 8 
  // if (currentTime > 4000 && currentTime <8000) {
  //   motorDriver.drive(0,120,0);
  // } else {
  //   motorDriver.drive(0,0,0);
  //}

  // DONT CHANGE CODE BELOW THIS LINE 
  // --------------------------------------------------------------------------

  
  if ( currentTime-printer.lastExecutionTime > LOOP_PERIOD ) {
    printer.lastExecutionTime = currentTime;
    printer.printValue(0,imu.printAccels());
    printer.printValue(1,imu.printRollPitchHeading());
    printer.printValue(2,motorDriver.printState());
    printer.printToSerial();  // To stop printing, just comment this line out
  }

  if ( currentTime-imu.lastExecutionTime > LOOP_PERIOD ) {
    imu.lastExecutionTime = currentTime;
    imu.read(); // this is a sequence of blocking I2C read calls
  }

  if ( currentTime-logger.lastExecutionTime > LOOP_PERIOD && logger.keepLogging) {
    logger.lastExecutionTime = currentTime;
    logger.log();
  }

}
