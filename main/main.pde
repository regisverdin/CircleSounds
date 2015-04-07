// To Do: Make an option to turn off/on the display of circles. could be a "presentation mode".


/////////////////////////////////Connecting with javascript//////////////////////////
interface JavaScript {
  // void showRadius(int x, int y);
  // void addNote(int x);
  // void newCircle();
  void attack(int parentIndex);
  void makeCircleSynth(float radius);

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
  size(1500, 1000);
  frameRate(300);
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
      circleArray.get(i).beatArray.get(j).checkForCollision(i,j);
      circleArray.get(i).beatArray.get(j).rotateBeat(i);
    }
  }
  utilFunctions.findCircleMouseOver(); /// does this do anything??
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
  if (key == 'b' && utilFunctions.mouseOnCircle){
    int i = utilFunctions.findCircleMouseOver();
    circleArray.get(i).addBeat(mouseX, mouseY);
  }

  if (key == 'i') {
    int i = utilFunctions.findCircleMouseOver();

    for (int j = 0; j < circleArray.get(i).intersectArray.size(); j++) {
      console.log(circleArray.get(i).intersectArray.get(j));
    }
    console.log(circleArray.get(i).intersectArray.size());
  }
}

void mouseReleased() {
  ///// 3: Save the circle in array
  mouseVal = false;
  if (key == 'c') {
    circle.saveCircle();
  }

  // 7: Calculate Intersection Points for each Circle (need to add this to other places later, if circles are moving on their own, or sound should change when user drags them)
  // Clear all current arraylists of intersections first
  for (int i = 0; i < circleArray.size() - 1; i++) {
    circleArray.get(i).intersectArray.clear();
    for (int j = i+1; j < circleArray.size(); j++) {
      circleArray.get(j).intersectArray.clear();
    }
  }
  // Find all intersections
  for (int i = 0; i < circleArray.size() - 1; i++) {
    for (int j = i+1; j < circleArray.size(); j++) {
      utilFunctions.findIntersections(i, j, circleArray.get(i).x, circleArray.get(i).y, circleArray.get(i).radius, circleArray.get(j).x, circleArray.get(j).y, circleArray.get(j).radius);
    }
  }
}





///////////////////////////////////////////////

public class Circle {
  int x = 0;
  int y = 0;
  protected float radius = 0; ///possible problem area... make sure int vs. float is correct
  int[] lineColors = {255, 255, 255};
  protected ArrayList<Beat> beatArray = new ArrayList<Beat>(); /// creates an arraylist of beats for each instance of Circle.
  protected ArrayList<PointObj> intersectArray = new ArrayList<PointObj>();/// holds positions of intersections. used by beat.

  void drawTempCircle() {
    int a = abs(x-mouseX);
    int b = abs(y-mouseY);
    radius = sqrt((a*a)+(b*b));
    ellipse(x, y, radius, radius);
  }
  void saveCircle() {
    circleArray.add(this);
    javascript.makeCircleSynth(this.radius);
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

  }
}

public class Beat extends Circle {
  float angle = 0;
  int absX = 0;
  int absY = 0;
  float rotationDistance = 5; // This is the Tempo... maybe. If too fast, beats will not be detected as colliding. Change tempo with the animation rate? Interpolate?
  float radius; ///QUESTION: why does radius always return the most recent circle radius, instead of the superclass of the current beat? I.e. why do i need to use i..., and why can't i just access radius on the current object's superobject.
  int parentIndex;
  private boolean beatOnCircle = false;
  int r = 0;
  int g = 256;
  int b = 0;

  void drawBeat(int i) {
    radius = circleArray.get(i).radius; /// see above question... why do i even have to define this, when circle's radius is protected?
    absX = int( (cos(angle) * radius) + circleArray.get(i).x ); /// QUESTION: same as above
    absY = int( (sin(angle) * radius) + circleArray.get(i).y );

    fill(r,g,b);
    ellipse(absX, absY, 3, 3);
    noFill();
  }
  
  void rotateBeat() {
    /// FUTURE PROBLEM TO FIX: angle indefinitely increases. Need to stop this... before memory problems
    angle += rotationDistance / (TWO_PI * radius); ////QUESTION: same as above
    // console.log(absX + " " + absY);
  }

  void checkForCollision(int i, int j) {

    testPoint = new PointObj(absX, absY);

    if (circleArray.get(parentIndex).intersectArray.contains(testPoint)) { ///Instead of this, check if angle >= 2PI beyond the testpoint. 
      beatOnCircle = true;
      console.log(parentIndex);
      javascript.attack(parentIndex);
      
    } else {
      beatOnCircle = false;
    }
  }
}

// Need this class because of equals method issue when using arraylist's contains method, in my checkForCollision method.
public class PointObj {
  int x;
  int y;
 
  PointObj (int x, int y)
  {
    this.x = x;
    this.y = y;
  }

  boolean equals(Object pointObj)
  {
    //Make sure we can compare these
    if(!(pointObj instanceof PointObj))
      return;
    
    //Cast the object to a Point and compare
    return this.x == ((PointObj) pointObj).x && this.y == ((PointObj) pointObj).y;
  }
}

public class UtilFunctions {
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

    a = new PointObj(xi1, yi1);
    b = new PointObj(xi2, yi2);
    c = new PointObj(xi1, yi1);
    d = new PointObj(xi2, yi2);

    circleArray.get(i).intersectArray.add(a);
    circleArray.get(i).intersectArray.add(b);
    circleArray.get(j).intersectArray.add(c);
    circleArray.get(j).intersectArray.add(d);

  }
}