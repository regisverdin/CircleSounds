//need to add beat to beatArray for correct Circle object.


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
Beat beat;
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
    circle.drawTemp();
  }
  ////// 4: Draw all circles added, by looping through arraylist.
  for (int i = 0; i < circleArray.size(); i++ ) {
    circleArray.get(i).drawFinal();
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
  if (key =='b' && mouseFunctions.onCircle == true) {
    beat = new Beat();
    console.log('blah')
    beat.drawNew();
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

  void drawTemp() {
    int a = abs(x-mouseX);
    int b = abs(y-mouseY);
    radius = sqrt((a*a)+(b*b));
    ellipse(x, y, radius, radius);
  }
  void saveCircle() {
    circleArray.add(this);
  }
  void drawFinal() {
    int r = lineColors[0];
    int g = lineColors[1];
    int b = lineColors[2];

    stroke(r, g, b);
    ellipse(x, y, radius, radius);
  }
}

class Beat extends Circle {
  
  float angle = 0; ///possible problem... maybe change to double or BigNumber

  void drawNew() {
      angle = asin(mouseFunctions.b / radius);
      console.log(angle);
  }
}

class MouseFunctions {
  int a, b;
  float c;
  boolean onCircle = false;

  void findCircleMouseOver() {

    for (int i = 0; i < circleArray.size(); i++) {
      a = mouseX - circleArray.get(i).x;
      b = mouseY - circleArray.get(i).y;
      c = sqrt((a*a)+(b*b)); //// Distance of mouse from center of current circle in array.

      if ((c >= (circleArray.get(i).radius - 20) && (c <= (circleArray.get(i).radius + 20) ) )) { //// If distance is within acceptable range, do something.
        console.log(i);
        onCircle = true;
        circleArray.get(i).lineColors = {170, 170, 170};
        
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
        onCircle = false;
        circleArray.get(i).lineColors = {256, 256, 256};
      }
    }
  }
}