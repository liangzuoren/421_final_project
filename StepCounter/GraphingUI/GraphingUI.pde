import org.gicentre.utils.spatial.*;
import org.gicentre.utils.network.*;
import org.gicentre.utils.network.traer.physics.*;
import org.gicentre.utils.geom.*;
import org.gicentre.utils.move.*;
import org.gicentre.utils.stat.*;
import org.gicentre.utils.gui.*;
import org.gicentre.utils.colour.*;
import org.gicentre.utils.text.*;
import org.gicentre.utils.*;
import org.gicentre.utils.network.traer.animation.*;
import org.gicentre.utils.io.*;

import processing.serial.*;
Serial myPort;
String val;
float[] steps = {0,0};
float[] date = {0,0};
boolean firstContact = false;
// Displays a simple line chart representing a time series.
 
XYChart lineChart;
void setup()
{
lineChart = new XYChart(this);
// Axis formatting and labels.
lineChart.showXAxis(true); 
lineChart.showYAxis(true); 
lineChart.setMinY(0);
     
lineChart.setYFormat("0");  // Monetary value in $US
lineChart.setXFormat("00,000");      // Year
   
// Symbol colours
lineChart.setPointColour(color(180,50,50,100));
lineChart.setPointSize(5);
lineChart.setLineWidth(2);
String portName = Serial.list()[0];
myPort = new Serial(this, portName, 9600);
size(500,200);
textFont(createFont("Arial",10),10); 
myPort.bufferUntil('\n');
}

void draw()
{
  background(255);
  textSize(9);
  lineChart.draw(15,15,width,height);
   
  // Draw a title over the top of the chart.
  fill(120);
  textSize(20);
  text("Steps Taken Over Time", 70,30);
}

void serialEvent(Serial myPort){
  //put the incoming data into a String
  //the \n is our end delimeter, indicating the end of a complete packet
  
 val = myPort.readStringUntil('\n');

 //make sure our data isn't empty before continuing
 if (val != null) {
   //trim whitespace and formatting characters (like carriage return)
   val = trim(val);
   
   if (firstContact == false) {
   if(val.equals("Start")){
   myPort.clear();
   firstContact = true;
   myPort.write('0');
   println("contact");
   }
   
   }
   
   else {
   
   if (val.contains("Steps")){
   myPort.clear();
   String[] stepsFromArduino = val.split(" ",2);
   float step = parseFloat(stepsFromArduino[1]);
   steps = append(steps, step);
   myPort.write('1');
   delay(500);
   }
   
   if(val.contains("Time")){
   myPort.clear();
   String[] timeFromArduino = val.split(" ",2);
   float time = parseFloat(timeFromArduino[1]);
   date = append(date,time);
   myPort.write('0');
   delay(500);
   }
   
   if (steps.length == date.length)
   {
   lineChart.setData(date, steps);
   
   } 
 }
   
}
}