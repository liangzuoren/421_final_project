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
String portName = Serial.list()[0];
myPort = new Serial(this, portName, 9600);
size(500,200);
textFont(createFont("Arial",10),10); 
myPort.bufferUntil('\n');
}

  // Draws the chart and a title.
void draw()
{
    if ( myPort.available() > 0)
  { 
    val = myPort.readStringUntil('\n');
  }
  println(val);
  float stepsFromArduino = parseFloat(val);
  println(steps);
  
    // Both x and y data set here.  
  lineChart = new XYChart(this);
  steps = append(steps, stepsFromArduino);
  date = append(date, stepsFromArduino);
  
  lineChart.setData(steps, date);
   
  // Axis formatting and labels.
  lineChart.showXAxis(true); 
  lineChart.showYAxis(true); 
  lineChart.setMinY(0);
     
  lineChart.setYFormat("##,###");  // Monetary value in $US
  lineChart.setXFormat("00.00");      // Year
   
  // Symbol colours
  lineChart.setPointColour(color(180,50,50,100));
  lineChart.setPointSize(5);
  lineChart.setLineWidth(2);
  
  background(255);
  textSize(9);
  lineChart.draw(15,15,width-30,height-30);
   
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
   println("val");
 
 //look for out 'A' string to start the handshake
 //if it's there, clear the buffer, and send a request for data
 if (firstContact ==false) {
   if (val.equals("A")) {
     myPort.clear();
     firstContact = true;
     myPort.write("A");
     println("contact");
   }
 }
 else { //if we've already established contact, keep getting and parsing data
   println(val);
   if (mousePressed ==true)
   { //if we clicked in the window
     myPort.write('1'); //send a 1
     println("1");
   }
   //when you've parsed the data you have, ask for more
   myPort.write("A");
 }
 }
}
 