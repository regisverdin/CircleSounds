// To Do: Make an option to turn off/on the display of circles. the beats moving look beautiful on their own, and create interesting patterns. could be a "presentation mode"

/////////////////////////////////Connecting with javascript//////////////////////////
interface JavaScript {
  void showRadius(int x, int y);
  void addNote(int x);
}

void bindJavascript(JavaScript js) {
  javascript = js;
}

JavaScript javascript;
//////////////////////////////////////////////////////////////////////////////////////


boolean mouseVal = false;
Circle circle;
ArrayList<Circle> circleArray = new ArrayList<Circle>(); //creates an arraylist for circle objects, and specifies the type in angle brackets(required!). automatically resizable.
MouseFunctions mouseFunctions = new MouseFunctions();


void setup(){
  size(1000, 1000);
  frameRate(100);
  ellipseMode(RADIUS);
  noFill();
  key = 'c';
}

void draw(){
  background(100, 100, 100);
  ///// 2: Draw new circle, while continually refreshing the background.
  if(mouseVal==true && key == 'c'){
    circle.drawTempCircle();
  }
  ////// 4: Draw all circles added, by looping through arraylist.
  for (int i = 0; i < circleArray.size(); i++ ) {
    circleArray.get(i).drawFinalCircle();
    //// 6: Draw and rotate all beats
    for (int j = 0; j < circleArray.get(i).beatArray.size(); j++) {
      circleArray.get(i).beatArray.get(j).drawBeat(i);
      circleArray.get(i).beatArray.get(j).rotateBeat(i);
    }
  }
  mouseFunctions.findCircleMouseOver();
}

void mousePressed() {
  if (key=='l') {
    for (int i = 0; i < circleArray.size(); i++ ) {
      // console.log("circle" + circleArray.get(i).radius);

      for (int j = 0; j < circleArray.get(i).beatArray.size(); j++) {
        console.log("beat" + i+ j + "=" + circleArray.get(i).beatArray.get(j).relx + ', ' + circleArray.get(i).beatArray.get(j).rely);
       }
    }
  }
  if (key == 'c') {
    circle = new Circle();
    circle.x = mouseX;
    circle.y = mouseY;
    mouseVal = true;
  }
  //// 5: Add a beat when clicking mouse.
  if (key == 'b' && mouseFunctions.mouseOnCircle == true){
    int i = mouseFunctions.findCircleMouseOver();
    circleArray.get(i).addBeat(mouseX, mouseY);
  }
}

void mouseReleased() {
  ///// 3: Save the circle in array
  mouseVal = false;
  if (key == 'c') {
    circle.saveCircle();
  }
}





///////////////////////////////////////////////

class Circle {
  int x = 0;
  int y = 0;
  float radius = 0; ///possible problem area... make sure int vs. float is correct
  int[] lineColors = {255, 255, 255};
  ArrayList<Beat> beatArray = new ArrayList<Beat>(); /// creates an arraylist of beats for each instance of Circle.

  void drawTempCircle() {
    int a = abs(x-mouseX);
    int b = abs(y-mouseY);
    radius = sqrt((a*a)+(b*b));
    ellipse(x, y, radius, radius);
  }
  void saveCircle() {
    circleArray.add(this);
  }
  void drawFinalCircle() {
    int r = lineColors[0];
    int g = lineColors[1];
    int b = lineColors[2];

    stroke(r, g, b);
    ellipse(x, y, radius, radius);
  }
  void addBeat() {
    Beat beat = new Beat();
    // console.log(mouseFunctions.a, mouseFunctions.b);
    beat.angle = asin(mouseFunctions.b/mouseFunctions.c);

    float compliment = PI - beat.angle; /// Find complimentary angle... needed for finding which quadrant beat is in. See Arcsin relation (not function!) for details...http://mathonweb.com/help_ebook/html/functions_2.htm
    /// Set angle to correct quadrant
    if (mouseFunctions.a < 0) {
      beat.angle = compliment;
    }
    if (mouseFunctions.a > 0 && mouseFunctions.b < 0) {
      beat.angle += TWO_PI;
    }
    beatArray.add(beat);
  }
}

class Beat extends Circle {
  float angle = 0; ///possible problem... maybe change to double or BigNumber
  int absx = 0;
  int absy = 0;
  float rotationDistance = 10;
  float radius; ///QUESTION: why does radius always return the most recent circle radius, instead of the superclass of the current beat? I.e. why do i need to use i..., and why can't i just access radius on the current object's superobject.

  void drawBeat(int i) {
    radius = circleArray.get(i).radius; /// see above question... why do i even have to define this?
    absx = int( (cos(angle) * radius) + circleArray.get(i).x ); /// QUESTION: same as above
    absy = int( (sin(angle) * radius) + circleArray.get(i).y );

    fill(0,256,0);
    ellipse(absx, absy, 3, 3);
    noFill();
  }
  
  void rotateBeat() {
    angle += rotationDistance / (TWO_PI * radius); ////QUESTION: same as above
  }
}

class MouseFunctions {
  int a, b;
  float c; //// Distance of mouse from center of current circle in array.
  boolean mouseOnCircle = false;

  int findCircleMouseOver() {

    for (i = 0; i < circleArray.size(); i++) {
      a = mouseX - circleArray.get(i).x;
      b = mouseY - circleArray.get(i).y;
      c = sqrt((a*a)+(b*b));

      if ((c >= (circleArray.get(i).radius - 10) && (c <= (circleArray.get(i).radius + 10) ) )) { //// If distance is within acceptable range, do something.
        mouseOnCircle = true;
        circleArray.get(i).lineColors = {170, 170, 170};
        return i;
      } else {
        mouseOnCircle = false;
        circleArray.get(i).lineColors = {255, 255, 255};
      }
    }
  }
}