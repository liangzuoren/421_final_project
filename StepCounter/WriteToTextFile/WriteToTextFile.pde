import processing.serial.*;
import java.io.*;
Serial mySerial;
PrintWriter output;

void setup() {
  mySerial = new Serial(this, Serial.list()[0], 9600);
  
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
      output.println(value);
    }
  }
}

void keyPressed() {
  output.flush();
  output.close();
  exit();
}