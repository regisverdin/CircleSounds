// //////////////////////Web Audio///////////////////////

var contextClass = (window.AudioContext || 
  window.webkitAudioContext || 
  window.mozAudioContext || 
  window.oAudioContext || 
  window.msAudioContext);
if (contextClass) {
  // Web Audio API is available.
  var context = new contextClass();
} else {
  // Web Audio API is not available. Ask the user to use a supported browser.
}

// // ////////// Functions called by Processing //////////////

// // // function showRadius(r) {
// // //   document.getElementById('radius').value = r;
// // // }

/* VCO */
var vco = context.createOscillator();
vco.type = vco.SINE;
vco.frequency.value = this.frequency;
vco.start(0);

/* VCA */
var vca = context.createGain();
vca.gain.value = 0;

/* Connections */
vco.connect(vca);
vca.connect(context.destination);

var noteOn;
if (noteOn){
  vca.gain.value = 1;
  console.log("play");
} else vca.gain.value = 0;

function playSound() {
  vco.frequency.value = 600;

  // oscillator = context.createOscillator(); // Create bass guitar 
  // gainNode = context.createGain(); // Create boost pedal  
  // oscillator.connect(gainNode); // Connect bass guitar to boost pedal 
  // gainNode.connect(context.destination); // Connect boost pedal to amplifier 
  // gainNode.gain.value = 0.7; // Set boost pedal to 30 percent volume 
  // oscillator.noteOn(0);
  // oscillator.frequency.value = freq * 3;
}

////////// Binding with Processing ///////////////////

var bound = false;

function bindJavascript() {
  var pjs = Processing.getInstanceById('main');
  if(pjs!=null) {
    pjs.bindJavascript(this);
    bound = true;
  }
  if(!bound) setTimeout(bindJavascript, 250);
}

bindJavascript();