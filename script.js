//////////////////////Web Audio///////////////////////

var context = new AudioContext(); // Create audio container with webkit prefix 

////////// Functions called by Processing //////////////

function showRadius(r) {
  document.getElementById('radius').value = r;
}

function addNote(x) {
  
  oscillator = context.createOscillator(); // Create bass guitar 
  gainNode = context.createGain(); // Create boost pedal  
  oscillator.connect(gainNode); // Connect bass guitar to boost pedal 
  gainNode.connect(context.destination); // Connect boost pedal to amplifier 
  gainNode.gain.value = 0.3; // Set boost pedal to 30 percent volume 
  oscillator.noteOn(0);
  oscillator.frequency.value = (x*2) + 100;
}


////////// Binding with Processing ///////////////////

var bound = false;

function bindJavascript() {
  var pjs = Processing.getInstanceById('maintest');
  if(pjs!=null) {
    pjs.bindJavascript(this);
    bound = true;
  }
  if(!bound) setTimeout(bindJavascript, 250);
}

bindJavascript();