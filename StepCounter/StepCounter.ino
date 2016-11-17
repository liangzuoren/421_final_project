#include <Adafruit_CircuitPlayground.h>
#include <Wire.h>
#include <SPI.h>
#include <Time.h>
#include <TimeLib.h>

// Counts the number of steps that you are taken using the accelerometer

float X,Y,Z;
int steps;
String val;
boolean recording = false;
boolean saveData = false;
#define TIME_HEADER  'T'   // Header tag for serial time sync message
#define TIME_REQUEST  'z'    // ASCII bell character requests a time sync message 
boolean synced = false;

void setup(void) {
  
  Serial.begin(9600);
  CircuitPlayground.begin();
  steps = 0;
}

void loop() {  
  if(synced == false){
     setSyncProvider(requestSync);  
     if (Serial.available()) {
        processSyncMessage();
     }
     if (timeStatus()!= timeNotSet) {
        digitalClockDisplay();  
     }
     if (timeStatus() == timeSet) {
        CircuitPlayground.setPixelColor(0, 0,   255,   0); // LED green if synced
        synced = true;
     } else {
        CircuitPlayground.setPixelColor(0, 255, 0, 0);  // LED red if needs refresh
     }
     delay(500);
  }
  
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
    Serial.print(".");
    Serial.print(hour());
    printDigits(minute());
    printDigits(second());
    Serial.print(" ");
    Serial.print(day());
    Serial.print("/");
    Serial.print(month());
    Serial.print("/");
    Serial.print(year());
    Serial.print("\n");
    saveData = false;
    delay(500);
  }
  
}

void digitalClockDisplay(){
  // digital clock display of the time
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
  // utility function for digital clock display: prints preceding colon and leading 0
  Serial.print(":");
  if(digits < 10)
    Serial.print('0');
  Serial.print(digits);
}


void processSyncMessage() {
  unsigned long pctime;
  const unsigned long DEFAULT_TIME = 1357041600; // Jan 1 2013

  if(Serial.find(TIME_HEADER)) {
     pctime = Serial.parseInt();
     if( pctime >= DEFAULT_TIME) { // check the integer is a valid time (greater than Jan 1 2013)
       setTime(pctime); // Sync Arduino clock to the time received on the serial port
     }
  }
}

time_t requestSync()
{
  Serial.print(TIME_REQUEST);  
  return 0; // the time will be sent later in response to serial msg
}

