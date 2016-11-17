import org.gicentre.utils.stat.*;    // For chart classes.
import java.io.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.*;
 
// Displays a simple line chart representing a time series.
 
XYChart lineChart;
List<Float> steps = new ArrayList<Float>(1000);
List<Float> time = new ArrayList<Float>(1000);
 
// Loads data into the chart and customises its appearance.
void setup()
{
  size(1000,500);
  textFont(createFont("Arial",20),20);
  
  String lines[] = loadStrings("C:\\Users\\Tony Ren\\Documents\\421_final_project\\StepCounter\\data.txt");
  for(int i = 0 ; i < lines.length; i=i+2){
    String[] parts = lines[i].split("\\.");
    steps.add(Float.valueOf(parts[0]));
    time.add(Float.valueOf(parts[1]));
  }
  
  float[] stepsGraph = new float[steps.size()]; 
  float[] timeGraph = new float[time.size()];
  
  for(int i=0;i<steps.size();i++){
     stepsGraph[i] = (float) steps.get(i);
     timeGraph[i] = (float) time.get(i);
  }
  
  // Both x and y data set here.  
  lineChart = new XYChart(this);
  lineChart.setData(timeGraph, stepsGraph);
   
  // Axis formatting and labels.
  lineChart.showXAxis(true); 
  lineChart.showYAxis(true); 
  lineChart.setMinY(0);
  textFont(createFont("Arial",10),10);
  lineChart.setXAxisLabel("Time(millis)");
  lineChart.setYAxisLabel("Steps");
  lineChart.setYFormat("000");  // Steps
  lineChart.setXFormat("000000");      // Time
   
  // Symbol colours
  lineChart.setPointColour(color(180,50,50,100));
  lineChart.setPointSize(5);
  lineChart.setLineWidth(2);
}
 
// Draws the chart and a title.
void draw()
{
  background(255);
  textSize(9);
  lineChart.draw(15,15,width-30,height-30);
   
  // Draw a title over the top of the chart.
  fill(120);
  textSize(30);
  text("Steps over Time", 70,30);
}