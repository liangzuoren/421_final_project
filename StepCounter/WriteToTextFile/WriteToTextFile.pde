import processing.serial.*;
import java.io.*;
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;

Serial mySerial;
PrintWriter output;
public static final String TIME_HEADER = "T";
public static final char TIME_REQUEST = 'z';
public static final char LF = 10;
public static final char CR = 13;
boolean timeRequest = false;

void setup() {
  mySerial = new Serial(this, Serial.list()[0], 9600);
  while (timeRequest == false){
    if(mySerial.available()>0){
      char val = char(mySerial.read());
      if (val == TIME_REQUEST){
        long t = getTimeNow();
        sendTimeMessage(TIME_HEADER, t);
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
  mySerial.clear();  
  File data = new File("C:\\Users\\Tony Ren\\Documents\\421_final_project\\StepCounter\\data.txt");
  try{
  if(!data.exists()){
  data.createNewFile(); 
  }
  output = new PrintWriter(new FileWriter(data,true));
  }catch(IOException e){
    System.out.println("Could not log");
  }
}

void draw() {
  if (mySerial.available() > 0){
    String value = mySerial.readStringUntil('\n');
    if ( value != null){
      value = value.replace("\n","").replace("\r","");
      output.println(value);
    }
  }
}

void keyPressed() {
  output.flush();
  output.close();
  exit();
}

void sendTimeMessage(String header, long time) {  
  String timeStr = String.valueOf(time);  
  mySerial.write(header);  // send header and time to arduino
  mySerial.write(timeStr); 
  mySerial.write('\n');  
}

long getTimeNow(){
  // java time is in ms, we want secs    
  Date d = new Date();
  Calendar cal = new GregorianCalendar();
  long current = d.getTime()/1000;
  long timezone = cal.get(cal.ZONE_OFFSET)/1000;
  long daylight = cal.get(cal.DST_OFFSET)/1000;
  return current + timezone + daylight; 
}