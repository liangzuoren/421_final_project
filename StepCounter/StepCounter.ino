#include <Adafruit_CircuitPlayground.h>
#include <Wire.h>
#include <SPI.h>

// Counts the number of steps that you are taken using the accelerometer
//

float X,Y,Z;
int steps;

void setup(void) {
  
  Serial.begin(9600);
  CircuitPlayground.begin();

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

  delay(500);
}
