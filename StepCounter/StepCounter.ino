#include <Adafruit_CircuitPlayground.h>
#include <Wire.h>
#include <SPI.h>
#include <Time.h>
#include <TimeLib.h>

// Circuit Playground based At-home Fitness Monitor
// Counts the number of steps that you are taken using the accelerometer
// Buzzes after a minute of rest
// LEDs will light during every successful step
// Must be run with Processing program WriteToTextFile.pde simultaneously due to the need for time syncing with a computer
// By: Tony Ren and Sanjana Ranganathan

float X,Y,Z; // Records the X,Y, and Z values from the accelerometer
int steps; // Records the amount of steps taken
double restTimeBegin; // Records beginning of "resting time"
double restTimeEnd; // Records end of "resting time"
double currentRestTime; // Records current "resting time" for use in alert
double restTime; // Records total resting time
boolean resting; // If user is resting, resting = true, if user is not resting, resting = false
boolean recording = false; // If user is recording, recording = true, if not then recording = false
boolean saveData = false; // If user presses button to save data, saveData = true
#define TIME_HEADER  'T'   // Header tag for serial time sync message
#define TIME_REQUEST  'z'    // ASCII bell character requests a time sync message 
boolean synced = false; // Keeping track of whether time is synced or not

void setup(void) {
  //Initializing Circuit Playground and the values for the steps and resting time
  Serial.begin(9600);
  CircuitPlayground.begin();
  steps = 0;
  restTime = 0;
}

void loop() {  
  //First checking if time is synced with the laptop or not
  if(synced == false){
    //If device is not synced, send a request to sync Circuit Playground with Processing
     setSyncProvider(requestSync);  
     //If the Serial port is available(done syncing), process the syncing message from the PC 
     if (Serial.available()) {
        processSyncMessage();
     }
     //Once the time is set, print current time then set the LED to green
     //If time is not set, the LED will turn on and be red
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

  //Once the time is synced, the user presses the right button on the Circuit Playground to start recording their "workout"
  if(CircuitPlayground.rightButton()){
   steps = 0; //Reset steps for each "workout"
   recording = true; //Change recording boolean to true
   resting = false; //Set resting boolean
   CircuitPlayground.setPixelColor(9, 0,  255,   0); //Turn a Green LED on 
  }

  //The user presses the left button on the Circuit Playground to stop recording their "workout"
  if(CircuitPlayground.leftButton()){
   recording = false; //Stop recording
   saveData = true; //Enable data saving
   CircuitPlayground.setPixelColor(9, 0,  0,   255); //Flash the blue LED
   delay(500);
   CircuitPlayground.setPixelColor(9, 0,  0,   0);
  }

  //Record 3 directions of motion from the accelerometer at all points in time once the device is recording
  if(recording == true){
  X = CircuitPlayground.motionX();
  Y = CircuitPlayground.motionY();
  Z = CircuitPlayground.motionZ();

  // Calculate the magnitutude of the motion vector
  float magnitude = sqrt(X*X+Y*Y+Z*Z);
  int threshold = 13;

  // If the user has not moved and the user is not already resting, make the device into a resting state
  if (magnitude < threshold && resting == false){
  restTimeBegin = millis();
  resting = true;
  }

  // Once the device is resting, calculate the amount of time the user has rested
  if (resting == true){
    currentRestTime = millis() - restTimeBegin;
    if (currentRestTime > 30000) { // If the user has rested for more than 30 seconds, play the tone until the user stops resting
      tone(5,196,1000/4);//196 is the tone for G3
      delay(250*1.3);
      noTone(5);
    }
  }

  // If the magnitude of the motion exceeds the threshold, count a step
  if (magnitude > threshold){
  steps = steps + 1;
  resting = false; // Turn resting state off
  restTimeEnd = millis(); //Record resting time if user rested more then 30 seconds
    if ((restTimeEnd - restTimeBegin)>30000){ 
    restTime = restTime + (restTimeEnd - restTimeBegin);
    }

  // Blink LEDs every time the user takes a step
  CircuitPlayground.setPixelColor(1, 128,  128,   128);
  CircuitPlayground.setPixelColor(2, 255,  0,   0);
  CircuitPlayground.setPixelColor(3, 0,  255,   0);
  CircuitPlayground.setPixelColor(4, 0,  0,   255);
  CircuitPlayground.setPixelColor(5, 128,  128,   0);
  CircuitPlayground.setPixelColor(6, 0,  128,   128);
  CircuitPlayground.setPixelColor(7, 128,  0,   128);
  CircuitPlayground.setPixelColor(8, 128,  128,   128);
  delay(200);
  CircuitPlayground.setPixelColor(1, 0,  0,   0);
  CircuitPlayground.setPixelColor(2, 0,  0,   0);
  CircuitPlayground.setPixelColor(3, 0,  0,   0);
  CircuitPlayground.setPixelColor(4, 0,  0,   0);
  CircuitPlayground.setPixelColor(5, 0,  0,   0);
  CircuitPlayground.setPixelColor(6, 0,  0,   0);
  CircuitPlayground.setPixelColor(7, 0,  0,   0);
  CircuitPlayground.setPixelColor(8, 0,  0,   0);
  }
  }

  // Printing the data that needs to be saved into the Serial port for Processing to receive
  if(saveData == true){
    Serial.print(steps); //Printing steps
    Serial.print(" "); 
    Serial.print(hour()); //Printing time
    Serial.print(".");
    Serial.print(minute()*100/60);
    Serial.print(" ");
    Serial.print(month()); //Printing date
    Serial.print("/");
    Serial.print(day());
    Serial.print("/");
    Serial.print(year());
    Serial.print(" ");
    Serial.print(restTime); //Printing rest time
    Serial.print("\n");
    saveData = false; //Turning data save state off
    delay(500);
  }

  else{
    delay(300);
  }
}

void digitalClockDisplay(){
  // digital clock display of the time
  Serial.print(hour());
  printDigits(minute());
  printDigits(second());
  Serial.print(" ");
  Serial.print(day());
  Serial.print("/");
  Serial.print(month());
  Serial.print("/");
  Serial.print(year()); 
  Serial.println(); 
}

void printDigits(int digits){
  // utility function for digital clock display: prints preceding colon and leading 0
  Serial.print(".");
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
{ //Request a time sync by printing a predetermined "Time request" character to the serial port, in this case, a z
  Serial.print(TIME_REQUEST);  
  return 0; // the time will be sent later in response to serial msg
}

