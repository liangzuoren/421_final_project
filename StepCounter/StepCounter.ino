#include <Adafruit_CircuitPlayground.h>
#include <Wire.h>
#include <SPI.h>
#include <Time.h>

// Counts the number of steps that you are taken using the accelerometer
//

float X,Y,Z;
int steps;

void setup(void) {
  
  Serial.begin(9600);
  CircuitPlayground.begin();
  establishContact();
  steps = 0;
}

void loop() {

  X = CircuitPlayground.motionX();
  Y = CircuitPlayground.motionY();
  Z = CircuitPlayground.motionZ();

  float magnitude = sqrt(X*X+Y*Y+Z*Z);
  int threshold = 13;
  if (magnitude > threshold){
  steps = steps + 1;
  }

  Serial.println(steps);
  digitalClockDisplay();

  if(CircuitPlayground.rightButton()){
    steps = 0;
  }

  delay(500);
}

void establishContact(){
  if (Serial.available() <= 0){
    Serial.println("A");
    delay(300);
  }

}

void digitalClockDisplay(){
Serial.print(hour());
printDigits(minute());
printDigits(second());
Serial.print(" ");
Serial.print(day());
Serial.print(" ");
Serial.print(month());
Serial.print(" ");
Serial.print(year());
Serial.println();
}

void printDigits(int digits){
Serial.print(":");
if(digits < 10){
  Serial.print('0');
  }
Serial.print(digits);
}



