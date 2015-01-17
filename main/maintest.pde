//circNum is not working properly: fix this first. Need to know which circle the mouse is over! That is the whole point of findCircleMouseOver function.
// then need to add beat to beatArray for correct Circle object. 

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
  }

  mouseFunctions.findCircleMouseOver();
}

void mousePressed() {
  ///// 1: User Starts Drawing New Circle, if c (default). mouseVal triggers the function in draw()
  if (key == 'c') {
    circle = new Circle();
    circle.x = mouseX;
    circle.y = mouseY;
    mouseVal = true;
  }
  //// 5: Add a beat when clicking mouse.
  if ((key == 'b') && (mouseFunctions.mouseOnCircle == true)){ // && circleArray.get(mouseFunctions.circNum).mouseOnCircle == true) {
    int i = mouseFunctions.findCircleMouseOver();
    console.log(circleArray.get(i));
    circleArray.get(i).addBeat();
    /// using circNum, get current circle mouse is over and add a new beat to it.
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
      beat.angle = atan(mouseX/mouseY);
      console.log(beat.angle);

      // beat.angle = asin(mouseFunctions.b / radius);
      // beatPosX = int(cos(angle)*circRadArr[i]);
      // beatPosY = int(sin(angle)*circRadArr[i]);
      // if (mouseX > circPosArr[i].x) {
      // beatPosX = 0-beatPosX;
      // console.log(beat.angle);
  }
}

class Beat extends Circle {
  float angle = 0; ///possible problem... maybe change to double or BigNumber
}

class MouseFunctions {
  int a, b;
  float c; /// This is the distance the mouse is from any circle's center.
  boolean mouseOnCircle = false;

  void findCircleMouseOver() {

    for (i = 0; i < circleArray.size(); i++) {
      a = mouseX - circleArray.get(i).x;
      b = mouseY - circleArray.get(i).y;
      c = sqrt((a*a)+(b*b)); //// Distance of mouse from center of current circle in array.

      if ((c >= (circleArray.get(i).radius - 20) && (c <= (circleArray.get(i).radius + 20) ) )) { //// If distance is within acceptable range, do something.
        mouseOnCircle = true;
        circleArray.get(i).lineColors = {170, 170, 170};
        return i;
        
        //FINDS POINT ON CIRCLE CLOSEST TO MOUSE CLICK
        // public float angle = asin(b/circRadArr[i]);
///////
        // angle = (angle * 180)/PI;
        // console.log(angle);
        // console.log(circRadArr[i]);
////////        
        // beatPosX = int(cos(angle)*circRadArr[i]);
        // beatPosY = int(sin(angle)*circRadArr[i]);
        
        // i = circleArray.size(); /// end the loop
      } else {
        mouseOnCircle = false;
        circleArray.get(i).lineColors = {255, 255, 255};
      }
    }
  }
}