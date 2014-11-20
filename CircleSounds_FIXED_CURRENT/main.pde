/////////////////////////////////Connecting with javascript//////////////////////////

interface JavaScript {
  void showRadius(int x, int y);
  void addNote(int x);
}

void bindJavascript(JavaScript js) {
  javascript = js;
}

JavaScript javascript;

//////////////////////////////////Main Processing Script////////////////////////////////////////



import java.util.Iterator;
import java.util.Map;

Circle circ;
Circle[] circs = new Circle[0];
CirclePosition circPos;
CirclePosition[] circPosArr = new CirclePosition[0];
Beat beat;
HashMap beatPosMap = new HashMap();
float[] circRadArr = new float[0];
int circRad;
int xPos;
int yPos;
int circNum;

//Makes mousePressed the return val of a function. Needed b/c of bug in processingjs (can't have func and var with same name).
boolean getMousePressValue() { return mousePressed; };
boolean mouseVal = getMousePressValue();








void setup() {
  size(1000, 1000);
  stroke(255);
  ellipseMode(RADIUS);
  noFill();
  mouseVal = false;
  circNum = 0;
  key = 'c';
}








void draw() {
  background(100, 100, 100);
  //// Draws a temporary circle while holding mouse down.
  if (mouseVal == true) {
    int a = abs(xPos-mouseX);
    int b = abs(yPos-mouseY);
    circRad = int( sqrt((a*a)+(b*b)) );

    circ.drawTempCircle(xPos, yPos, circRad, circRad);
  }

  //// Updates and displays all circle objects in array.
  for (int i = 0; i < circs.length; i++ ) { 
    circs[i].drawCircle();
  }
  //// Updates and displays all beats in beatPosMap
//  for (int i = 0; i < circs.length; i++ ) { 
//    beatPosMap.get(str(i)).x
//  }
//  Iterator iter = beatPosMap.entrySet().iterator();  // Get an iterator, iterate through map
//  while (iter.hasNext ()) {
//    Map.Entry me = (Map.Entry)iter.next();
//    print(me.getKey() + " is ");
//    println(me.getValue());
//  }
}











/// Need to remove mousePressed, and put this code into a few separate functions. Causes errors when I try.. get help.
void mousePressed() {
  ///// User Starts Drawing New Circle, if c (default)
  if (key == 'c') {
    circ = new Circle();
    
    //add current mouse position (center of new circle) to CirclePosition array
    int a = mouseX;
    int b = mouseY;
    circPos = new CirclePosition(a, b);
    circPosArr = (CirclePosition[]) append(circPosArr, circPos);
    //
    
    mouseVal = true;
    xPos = mouseX;
    yPos = mouseY;
  }

  //// User adds beats, if b
  if (key == 'b') {
    for (int i = 0; i < circNum; i++) {
      float a = abs(circPosArr[i].x-mouseX);
      float b = abs(circPosArr[i].y-mouseY);
      int c = int( sqrt((a*a)+(b*b)) );

      if ((c >= (circRadArr[i]-10) && (c <= (circRadArr[i]+10)))) {
        println("On the circle!");

     float angle = asin(b/circRadArr[i]); // get angle of triangle between mousepos and circlepos. use this to scale the triangle to have hyp=circRad, and get the coordinates of the point on the circle circumference. 
        println(angle);
        
        int beatPosX = mouseX;
        int beatPosY = mouseY;
        beat = new Beat(beatPosX, beatPosY);
        //beat = new Beat(circPosArr[i].x, circPosArr[i].y);
//        println(beat.beatX);
//        println(beat.beatY);
        beatPosMap.put(str(i), beat);
//        println(beatPosMap.get(str(i)), beat.beatX);
        //need to also continuously draw beats... place that in draw function, (see iterator)

        //beatPosArr[i] = new Beat();
        //Beat.addBeat
        //add beat to that circle
      }

      //      if ( ( mouseX <= ((circPosArr[i].x) + 20) ) && ( mouseX >= ((circPosArr[i].x) - 20) )    &&    ( mouseY <= ((circPosArr[i].y) + 20) ) && ( mouseY >= ((circPosArr[i].y) - 20) )) {
      //         //println("In Range");
      //         int a = mouseX;
      //         int b = mouseY;
      //         translate(mouseX-a, mouseY-b);
      //         }
    }

    /* move circle by clicking and dragging center. need to also move beats with it!
     if (key == 'b') {
     for (int i = 0; i < circNum; i++) {
     println(circPosArr[i].x);
     if ( ( mouseX <= ((circPosArr[i].x) + 20) ) && ( mouseX >= ((circPosArr[i].x) - 20) )    &&    ( mouseY <= ((circPosArr[i].y) + 20) ) && ( mouseY >= ((circPosArr[i].y) - 20) )) {
     */
  }
}



  void mouseReleased() {

    /// Adds drawn circle to array
    if (key == 'c') {
      circs = (Circle[]) append(circs, circ);
      //println(circs[circNum]);
      circNum++;
      circ = new Circle();
      mouseVal = false;
      
      //Add current mouse position (at RADIUS of new circle) to circRadArr array
     
      int a = abs(xPos-mouseX);
      int b = abs(yPos-mouseY);
      float circRad = sqrt((a*a)+(b*b));
      circRadArr = append(circRadArr, circRad);
      
      javascript.addNote(circRad);
      javascript.showRadius(circRad);
    }
  }









  ///////////////////////////////////////////////////  CLASSES  //////////////////////////////////////////////////////////////////

  class Circle {
    int circleX;
    int circleY;
    int circleW;
    int circleH;

    Circle() {
    } 

    void drawTempCircle(int a, int b, int c, int d) {
      circleX = a;
      circleY = b;
      circleW = c;
      circleH = d;
      ellipse(circleX, circleY, circleW, circleH);
    }
    void drawCircle() {
      ellipse(circleX, circleY, circleW, circleH);
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  class CirclePosition {
    int x;
    int y;

    CirclePosition(int a, int b) {
      x = a;
      y = b;
    }
  }


  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  class Beat {
    int beatX;
    int beatY;

    Beat() {
    }

    void addBeat(int x, int y) {
      beatX = x;
      beatY = y;
    }
  }