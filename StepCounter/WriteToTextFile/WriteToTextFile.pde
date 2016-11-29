import processing.serial.*;
import java.io.*;
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;

// Processing application that should be run simultaneously as the StepCounter.ino file to record steps
// Syncs time with computer and then records data into a text file
// Written By: Tony Ren and Sanjana Ranganathan

Serial mySerial; // Initializing Serial port
PrintWriter output; // Initializing PrintWriter for recording to text file
public static final String TIME_HEADER = "T"; // Standardized Time Header
public static final char TIME_REQUEST = 'z'; // Standardized TIme Request Character
public static final char LF = 10; //ASCII linefeed character
public static final char CR = 13; //ASCII linefeed character
boolean timeRequest = false; // Time request boolean

void setup() {
  mySerial = new Serial(this, Serial.list()[0], 9600); //Choose the first serial port on the serial list as my serial and initialize it
  while (timeRequest == false){ //While no time request, read the Serial report for a request
    if(mySerial.available()>0){ //When Serial port is unavailable(arduino writing to Serial port)
      char val = char(mySerial.read()); //Read the serial port 
      if (val == TIME_REQUEST){ // If Serial port reads a time request character 
        long t = getTimeNow(); // Obtain current time from the computer
        sendTimeMessage(TIME_HEADER, t); //And send the time to the arduino
        timeRequest = true; 
      }
      else{
        if (val == LF)
          ;
        else if (val == CR)
          println();
        else
          print(val);
      }
    }
    delay(500);
  }
  
  //Clear Serial Port to avoid writing unintentional things
  mySerial.clear();  
  File data = new File("C:\\Users\\Tony Ren\\Documents\\421_final_project\\StepCounter\\data.txt"); //Set file location
  try{
  if(!data.exists()){
  data.createNewFile(); //Create new file if file does not exist
  }
  output = new PrintWriter(new FileWriter(data,true)); //Create new printwriter object for the file
  }catch(IOException e){
    System.out.println("Could not log"); //Return error message "could not log" if this process returns an error
  }
}

void draw() {
  if (mySerial.available() > 0){ //Read the Serial feed if there is something being written
    String value = mySerial.readStringUntil('\n'); //Read until the next line
    if ( value != null){ //Record values into text file
      value = value.replace("\n","").replace("\r","");
      output.println(value);
    }
  }
}

// Once any key is pressed, the program will flush the Serial output and close the program
void keyPressed() {
  output.flush();
  output.close();
  exit();
}

// Format time message and send it to the Arduino
void sendTimeMessage(String header, long time) {  
  String timeStr = String.valueOf(time);  
  mySerial.write(header);  // send header and time to arduino
  mySerial.write(timeStr); 
  mySerial.write('\n');  
}


// Obtains the current time in second form from the computer
long getTimeNow(){
  // java time is in ms, we want secs    
  Date d = new Date();
  Calendar cal = new GregorianCalendar();
  long current = d.getTime()/1000;
  long timezone = cal.get(cal.ZONE_OFFSET)/1000;
  long daylight = cal.get(cal.DST_OFFSET)/1000;
  return current + timezone + daylight; 
}