#include <Adafruit_CircuitPlayground.h>
#include <Wire.h>
#include <SPI.h>
#include <Time.h>
#include <DateTime.h>

// Counts the number of steps that you are taken using the accelerometer
//

float X,Y,Z;
int steps;
String val;
boolean recording = false;
boolean saveData = false;

void setup(void) {
  
  Serial.begin(9600);
  CircuitPlayground.begin();
  steps = 0;
}

void loop() {
  getPCtime();
  
  if(CircuitPlayground.rightButton()){
   steps = 0;
   recording = true; 
  }

  if(CircuitPlayground.leftButton()){
   recording = false;
   saveData = true;
  }

  if(recording == true){
  X = CircuitPlayground.motionX();
  Y = CircuitPlayground.motionY();
  Z = CircuitPlayground.motionZ();

  float magnitude = sqrt(X*X+Y*Y+Z*Z);
  int threshold = 13;

  
  if (magnitude > threshold){
  steps = steps + 1;
  }
  delay(200);
  }

  if(saveData == true){
    Serial.print(steps);
    Serial.print(" ");
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
    Serial.print("\n");
    saveData = false;
    delay(500);
  }
  
}

void digitalClockDisplay(){
//Serial.print(hour());
//printDigits(minute());
//printDigits(second());
//Serial.print(" ");
//Serial.print(day());
//Serial.print(" ");
//Serial.print(month());
//Serial.print(" ");
//Serial.print(year());
//Serial.println();
Serial.print(millis());
Serial.print("\n");
}

void printDigits(int digits){
Serial.print(":");
if(digits < 10){
  Serial.print('0');
  }
Serial.print(digits);
}

void getPCtime() {
  // if time available from serial port, sync the DateTime library
  while(Serial.available() >=  TIME_MSG_LEN ){  // time message
    if( Serial.read() == TIME_HEADER ) {        
      time_t pctime = 0;
      for(int i=0; i < TIME_MSG_LEN -1; i++){   
        char c= Serial.read();          
        if( c >= '0' && c <= '9')   
          pctime = (10 * pctime) + (c - '0') ; // convert digits to a number            
      }   
      DateTime.sync(pctime);   // Sync DateTime clock to the time received on the serial port
    }  
  }
}
