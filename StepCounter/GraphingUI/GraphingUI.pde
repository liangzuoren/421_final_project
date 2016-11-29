import org.gicentre.utils.stat.*;    // For chart classes.
import java.io.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.*;
import javax.swing.*;
import java.util.Date;
import java.text.*;
 
// Displays three charts displaying steps, calories burned, and total resting time
// Written by: Tony Ren and Sanjana Ranganathan
 
XYChart stepsTimeGraph; //Initializing graphs
XYChart caloriesBurnedGraph;
XYChart restingTimeGraph;
List<Float> steps = new ArrayList<Float>(1000); //Initializing ArrayLists
List<Float> time = new ArrayList<Float>(1000);
List<Date> date = new ArrayList<Date>(1000);
List<Float> restTime = new ArrayList<Float>(1000);
float[] calories; //Initializing float arrays to graph
float[] timeGraph; 
float[] restGraph;
float[] GraphingDates; 

void settings(){
  size(1000,500); //Create new window size 1000 by 500
}
// Loads data into the chart and customises its appearance.
void setup()
{
  textFont(createFont("Arial",20),20); 
  DateFormat df = new SimpleDateFormat("mm/dd/yyyy"); //Set date format
    
  String lines[] = loadStrings("C:\\Users\\Tony Ren\\Documents\\421_final_project\\StepCounter\\data.txt"); //Load strings line by line from text file 
  for(int i = 0 ; i < lines.length; i++){ 
    String[] parts = lines[i].split(" "); //Split each line by the space
    steps.add(Float.valueOf(parts[0])); //Add steps into array list
    time.add(Float.valueOf(parts[1])); //Add time into array list
    try {
    date.add(df.parse(parts[2])); //Add dates into array list
    } catch (java.text.ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
    }
    restTime.add(Float.valueOf(parts[3])); //Add rest times into array list
  }
  
  //Initializing steps and dates arrays
  float[] stepsGraph = new float[steps.size()]; 
  timeGraph = new float[time.size()];
  String[] dateGraph = new String[date.size()];
  restGraph = new float[restTime.size()];
  
  for(int i=0;i<steps.size();i++){
     stepsGraph[i] = (float) steps.get(i); //Convert steps, time and rest time into floats from Floats
     timeGraph[i] = (float) time.get(i);
     dateGraph[i] = df.format(date.get(i)); //Convert dates back into strings
     restGraph[i] = (float) restTime.get(i);
  }
  
  calories = new float[stepsGraph.length]; //Calculate calories burned from steps
  for (int i=0; i< stepsGraph.length;i++){
  calories[i] = stepsGraph[i] * 0.05;
  }
  
  GraphingDates = new float[dateGraph.length]; //Initializing float array to graph dates
  
  for (int i=0; i<dateGraph.length;i++){
  String[] parts = dateGraph[i].split("/"); //Seperate month from day
  Float MonthValue = Float.valueOf(parts[0]); //Obtain Float values from the strings
  Float DayValue = Float.valueOf(parts[1]);
  float Monthfloat= ((float) MonthValue)*10000; //Change the Float values to floats
  float Dayfloat = ((float) DayValue)*100; //into format "MMDDHH.SS"
  GraphingDates[i] = Monthfloat + Dayfloat + timeGraph[i];
  }
 

  // Both x and y data set
  stepsTimeGraph = new XYChart(this);
  stepsTimeGraph.setData(GraphingDates, stepsGraph); //Setting x as Dates and y as Steps
   
  // Axis formatting and labels.
  stepsTimeGraph.showXAxis(true); 
  stepsTimeGraph.showYAxis(true); 
  stepsTimeGraph.setMinY(0);
  textFont(createFont("Arial",10),10);
  stepsTimeGraph.setXAxisLabel("Date(MMDDHH.SS)");
  stepsTimeGraph.setYAxisLabel("Steps");
  stepsTimeGraph.setYFormat("000");  // Steps
  stepsTimeGraph.setXFormat("000000.00");  // Time
   
  // Symbol colours
  stepsTimeGraph.setPointColour(color(180,50,50,100));
  stepsTimeGraph.setPointSize(5);
  stepsTimeGraph.setLineWidth(2); 
  
  //Graph second graph
  String[] args = {"Second Window"};
  SecondApplet sa = new SecondApplet();
  PApplet.runSketch(args, sa);
  //Graph third graph
  String[] args3 = {"Third Window"};
  ThirdApplet sa3 = new ThirdApplet();
  PApplet.runSketch(args3, sa3);
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
  //Setting x as Dates and y as Calories Burned
  caloriesBurnedGraph = new XYChart(this);
  caloriesBurnedGraph.setData(GraphingDates,calories);
  
  caloriesBurnedGraph.showXAxis(true); 
  caloriesBurnedGraph.showYAxis(true); 
  caloriesBurnedGraph.setMinY(0);
  textFont(createFont("Arial",10),10);
  caloriesBurnedGraph.setXAxisLabel("Date(MMDDHH.SS)");
  caloriesBurnedGraph.setYAxisLabel("Calories");
  caloriesBurnedGraph.setYFormat("000");  // Calories
  caloriesBurnedGraph.setXFormat("000000.00");      // Time
   
  // Symbol colours
  caloriesBurnedGraph.setPointColour(color(180,50,50,100));
  caloriesBurnedGraph.setPointSize(5);
  caloriesBurnedGraph.setLineWidth(2);
 
  }
  public void draw(){
  background(255);
  textSize(9);
  caloriesBurnedGraph.draw(15,15,width-30,height-30);
  //Graph Title
  fill(120);
  textSize(30);
  text("Calories Burned Over Time", 70, 30);
  }
}

public class ThirdApplet extends PApplet{
  public void settings(){
  size(1000,500);
  }
  public void setup(){
   float[] restGraphMinutes = new float[restGraph.length];
    for (int i = 0;i < restGraph.length;i++){
      restGraphMinutes[i] = restGraph[i]/60000;
    }
  //Setting x and y date as Dates and Resting Time
  restingTimeGraph = new XYChart(this);
  restingTimeGraph.setData(GraphingDates,restGraphMinutes);
  
  restingTimeGraph.showXAxis(true); 
  restingTimeGraph.showYAxis(true); 
  restingTimeGraph.setMinY(0);
  textFont(createFont("Arial",10),10);
  restingTimeGraph.setXAxisLabel("Date(MMDDHH.SS)");
  restingTimeGraph.setYAxisLabel("Resting Time(minutes)");
  restingTimeGraph.setYFormat("0.000");  // Resting Time
  restingTimeGraph.setXFormat("000000.00");  // Time
   
  // Symbol colours
  restingTimeGraph.setPointColour(color(180,50,50,100));
  restingTimeGraph.setPointSize(5);
  restingTimeGraph.setLineWidth(2);
  }
  public void draw(){
  background(255);
  textSize(9);
  restingTimeGraph.draw(15,15,width-30,height-30);
  //Graph Title
  fill(120);
  textSize(30);
  text("Resting Time Per Workout", 70, 30);
  }
}