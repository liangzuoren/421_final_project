import org.gicentre.utils.stat.*;    // For chart classes.
import java.io.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.*;
import javax.swing.*;
 
// Displays a simple line chart representing a time series.
 
XYChart stepsTimeGraph;
XYChart caloriesBurnedGraph;
List<Float> steps = new ArrayList<Float>(1000);
List<Float> time = new ArrayList<Float>(1000);
List<Float> date = new ArrayList<Float>(1000);
float[] calories;
float[] timeGraph; 

void settings(){
  size(1000,500);
}
// Loads data into the chart and customises its appearance.
void setup()
{
  textFont(createFont("Arial",20),20);
    
  String lines[] = loadStrings("C:\\Users\\Tony Ren\\Documents\\421_final_project\\StepCounter\\data.txt");
  for(int i = 0 ; i < lines.length; i=i+2){
    String[] parts = lines[i].split(" ");
    steps.add(Float.valueOf(parts[0]));
    time.add(Float.valueOf(parts[1]));
 //   date.add(Float.valueOf(parts[2]));
  }
  
  float[] stepsGraph = new float[steps.size()]; 
  timeGraph = new float[time.size()];
  //float[] dateGraph = new float[date.size()];
  
  for(int i=0;i<steps.size();i++){
     stepsGraph[i] = (float) steps.get(i);
     timeGraph[i] = (float) time.get(i);
  //   dateGraph[i] = (float) date.get(i);
  }
  
  calories = new float[stepsGraph.length];
  for (int i=0; i< stepsGraph.length;i++){
  calories[i] = stepsGraph[i] * 0.05;
  }

  // Both x and y data set here.  
  stepsTimeGraph = new XYChart(this);
  stepsTimeGraph.setData(timeGraph, stepsGraph);
   
  // Axis formatting and labels.
  stepsTimeGraph.showXAxis(true); 
  stepsTimeGraph.showYAxis(true); 
  stepsTimeGraph.setMinY(0);
  textFont(createFont("Arial",10),10);
  stepsTimeGraph.setXAxisLabel("Time(hours)");
  stepsTimeGraph.setYAxisLabel("Steps");
  stepsTimeGraph.setYFormat("000");  // Steps
  stepsTimeGraph.setXFormat("000.00");      // Time
   
  // Symbol colours
  stepsTimeGraph.setPointColour(color(180,50,50,100));
  stepsTimeGraph.setPointSize(5);
  stepsTimeGraph.setLineWidth(2); 
  
  String[] args = {"Second Window"};
  SecondApplet sa = new SecondApplet();
  PApplet.runSketch(args, sa);
}
 
// Draws the chart and a title.
void draw()
{
  background(255);
  textSize(9);
  stepsTimeGraph.draw(15,15,width-30,height-30);
   
  // Draw a title over the top of the chart.
  fill(120);
  textSize(30);
  text("Steps over Time", 70,30);

}

public class SecondApplet extends PApplet{
  public void settings(){
  size(1000,500);
  }
  public void setup(){
  caloriesBurnedGraph = new XYChart(this);
  caloriesBurnedGraph.setData(timeGraph,calories);
  
  caloriesBurnedGraph.showXAxis(true); 
  caloriesBurnedGraph.showYAxis(true); 
  caloriesBurnedGraph.setMinY(0);
  textFont(createFont("Arial",10),10);
  caloriesBurnedGraph.setXAxisLabel("Time(hours)");
  caloriesBurnedGraph.setYAxisLabel("Calories");
  caloriesBurnedGraph.setYFormat("000");  // Calories
  caloriesBurnedGraph.setXFormat("000.00");      // Time
   
  // Symbol colours
  caloriesBurnedGraph.setPointColour(color(180,50,50,100));
  caloriesBurnedGraph.setPointSize(5);
  caloriesBurnedGraph.setLineWidth(2);
 
  }
  public void draw(){
  background(255);
  textSize(9);
  caloriesBurnedGraph.draw(15,15,width-30,height-30);
  
  fill(120);
  textSize(30);
  text("Calories Burned Over Time", 70, 30);
  }
}