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
UtilFunctions utilFunctions = new UtilFunctions();

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
    //// 6: Draw and rotate all beats, and check for collisions.
    for (int j = 0; j < circleArray.get(i).beatArray.size(); j++) {
      circleArray.get(i).beatArray.get(j).drawBeat(i);
      circleArray.get(i).beatArray.get(j).checkForCollision();
      circleArray.get(i).beatArray.get(j).rotateBeat(i);
    }
  }
  utilFunctions.findCircleMouseOver();
  // 7: Calculate Intersection Points for each Circle
  for (int i = 0; i < circleArray.size(); i++) {
    for (int j = i+1; j < circleArray.size(); j++)
      utilFunctions.findIntersections(i, j, circleArray.get(i).x, circleArray.get(i).y, circleArray.get(i).radius, circleArray.get(j).x, circleArray.get(j).y, circleArray.get(j).radius);
  }
}

void mousePressed() {
  // if (key=='l') {
  //   for (int i = 0; i < circleArray.size(); i++ ) {
  //     console.log("circle" + circleArray.get(i).radius);

  //     for (int j = 0; j < circleArray.get(i).beatArray.size(); j++) {
  //       console.log("beat" + i+ j + "=" + circleArray.get(i).beatArray.get(j).relx + ', ' + circleArray.get(i).beatArray.get(j).rely);
  //      }
  //   }
  // }

  if (key == 'c') {
    circle = new Circle();
    circle.x = mouseX;
    circle.y = mouseY;
    mouseVal = true;
  }
  //// 5: Add a beat when clicking mouse.
  if (key == 'b' && utilFunctions.mouseOnCircle == true){
    int i = utilFunctions.findCircleMouseOver();
    circleArray.get(i).addBeat(mouseX, mouseY);
  }

  if (key == 'i') {
    int i = utilFunctions.findCircleMouseOver();
    console.log(i);
    for (int j = 0; j < circleArray.get(j).intersectArray.size() - 1; j++) {
      console.log(circleArray.get(i).intersectArray.get(j));
    }
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
  ArrayList<int[]> intersectArray = new ArrayList<int[]>();/// holds positions of intersections. used by beat.

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
    // console.log(utilFunctions.a, utilFunctions.b);
    beat.angle = asin(utilFunctions.b/utilFunctions.c);

    float compliment = PI - beat.angle; /// Find complimentary angle... needed for finding which quadrant beat is in. See Arcsin relation (not function!) for details...http://mathonweb.com/help_ebook/html/functions_2.htm
    /// Set angle to correct quadrant
    if (utilFunctions.a < 0) {
      beat.angle = compliment;
    }
    if (utilFunctions.a > 0 && utilFunctions.b < 0) {
      beat.angle += TWO_PI;
    }
    beatArray.add(beat);

    /// A workaround so beat objects can access index of their parent object.
    beat.parentIndex = circleArray.indexOf(this);
    console.log(beat.parentIndex);
  }
}

class Beat extends Circle {
  float angle = 0; ///possible problem... maybe change to double or BigNumber
  int absX = 0;
  int absY = 0;
  float rotationDistance = 10;
  float radius; ///QUESTION: why does radius always return the most recent circle radius, instead of the superclass of the current beat? I.e. why do i need to use i..., and why can't i just access radius on the current object's superobject.
  int parentIndex;
  boolean beatOnCircle = false;

  void drawBeat(int i) {
    radius = circleArray.get(i).radius; /// see above question... why do i even have to define this?
    absX = int( (cos(angle) * radius) + circleArray.get(i).x ); /// QUESTION: same as above
    absY = int( (sin(angle) * radius) + circleArray.get(i).y );

    fill(0,256,0);
    ellipse(absX, absY, 3, 3);
    noFill();
  }
  
  void rotateBeat() {
    angle += rotationDistance / (TWO_PI * radius); ////QUESTION: same as above
  }

  // void checkForCollision() {

  //   for (i = 0; i < circleArray.size(); i++) {
  //     if (i != parentIndex) {           /// Excludes own circle from loop, else always true.
  //       a = absX - circleArray.get(i).x;
  //       b = absY - circleArray.get(i).y;
  //       c = sqrt((a*a)+(b*b));

  //       if ((c >= circleArray.get(i).radius -1) && (c <= circleArray.get(i).radius +1)) { /// QUESTION: Might cause problems, check this range.
  //         beatOnCircle = true;
  //         console.log(beatOnCircle);
  //         circleArray.get(parentIndex).lineColors = {0, 200, 170};
  //       } else {
  //         beatOnCircle = false;
  //         circleArray.get(parentIndex).lineColors = {255, 255, 255};
  //       }
  //     }
  //   }
  // }
}

class UtilFunctions {
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
  void findIntersections(i, j, x0, y0, r0, x1, y1, r1) {
    // using this: http://justbasic.wikispaces.com/Check+for+collision+of+two+circles,+get+intersection+points
    // Get distance d between circle centers
    int dx = x1 - x0;
    int dy = y1 - y0;
    float d = sqrt((dy*dy) + (dx*dx));

    // Check for solvability
    if (d > (r0 + r1)) {
      return // Circles are too far
    }
    if (d < abs(r0 - r1)) {
      return // One circle is inside the other
    }

    float a = ((r0*r0) - (r1*r1) + (d*d)) / (2.0 * d);

    float x2 = x0 + (dx * a/d);
    float y2 = y0 + (dy * a/d);

    float h = sqrt((r0*r0) - (a*a));

    float rx = (0-dy) * (h/d);
    float ry = dx * (h/d);

    int xi1 = int(x2 + rx);
    int xi2 = int(x2 - rx);
    int yi1 = int(y2 + ry);
    int yi2 = int(y2 - ry);

    circleArray.get(i).intersectArray.add([xi1, yi1]);
    circleArray.get(i).intersectArray.add([xi2, yi2]); 
    circleArray.get(j).intersectArray.add([xi1, yi1]);
    circleArray.get(j).intersectArray.add([xi2, yi2]);
  }
}