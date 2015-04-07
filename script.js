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

////////////// Functions called by Processing //////////////

// function showRadius(r) {
//   document.getElementById('radius').value = r;
// }

// /* VCO */
// var vco = context.createOscillator();
// vco.type = vco.SIN;
// vco.frequency.value = this.frequency;
// vco.start(0);

//  VCA 
// var vca = context.createGain();
// vca.gain.value = 0;

// /* Connections */
// vco.connect(vca);
// vca.connect(context.destination);

// function playSound(freq) {

//   vco.frequency.value = 1000 - freq * 3 ;
//   vca.gain.value = 1;
//   window.setTimeout(function() {vca.gain.value = 0}, 100);
// }


///////////////////////////////////////////////////////////////////


// var synthMap = {};

// // Each time a circle is made in processing, make a new synth object. Add to synthMap object.
// function newCircle(id) {
//   var synth = new Synth(id);
//   synthMap[id] = synth;
// }


// function Synth(freq) {

//   /* VCO */
//   var vco = context.createOscillator();
//   vco.type = vco.SIN;
//   vco.frequency.value = this.frequency;
//   vco.start(0);

//   /* VCA */
//   var vca = context.createGain();
//   vca.gain.value = 0;

//    Connections 
//   vco.connect(vca);
//   vca.connect(context.destination);

// //   vco.frequency.value = 1000 - freq * 3 ;
// //   vca.gain.value = 1;
// //   window.setTimeout(function() {vca.gain.value = 0}, 100);
// // }

// function attack(id) {
//   synth = synthMap[id];
//   console.log("hello");
//   synth.vco.frequency.value = 1000 - freq * 3 ;
//   synth.vca.gain.value = 1;
//   window.setTimeout(function() {synth.vca.gain.value = 0}, 100);
// }
//   // envelope here
// }

////////////////////////////////////////////////////////////////////////////////////////////////////////

// Create a compressor node
var compressor = context.createDynamicsCompressor();
compressor.threshold.value = -20;
compressor.knee.value = 40;
compressor.ratio.value = 0.5;
compressor.reduction.value = -20;
compressor.attack.value = 0.1;
compressor.release.value = 0.25;
compressor.connect(context.destination);



var voiceBank = {};

var Voice = (function(context) {
  function Voice(frequency){
    this.vca        = context.createGain();
    this.vco        = context.createOscillator();
    this.frequency  = frequency;
  };

  Voice.prototype.start = function() {
    
    //this.vco.type = this.vco.SINE;

    this.vco.frequency.value = this.frequency;
    this.vca.gain.value = 0.0;
    this.vco.connect(this.vca);
    this.vca.connect(compressor);

    this.vco.start(0);
  };

  Voice.prototype.trigger = function() {
    now = context.currentTime;

    this.vca.gain.cancelScheduledValues(now);
    this.vca.gain.linearRampToValueAtTime(0, now + 0.1);
    this.vca.gain.linearRampToValueAtTime(0.7, now + 0.5);
    this.vca.gain.linearRampToValueAtTime(0, now + 0.5 + 1.5);

  };


  return Voice;
})(context);



function makeBeatSynth(radius, circleIndex, beatIndex) {
  var frequency = 2 * radius;
  var voice = new Voice(frequency);

  if (!voiceBank[circleIndex]) {
    voiceBank[circleIndex] = {};
  }
  voiceBank[circleIndex][beatIndex] = voice;
  voice.start();
}

function attack(circleIndex, beatIndex) {

  var circleSynth = voiceBank[circleIndex][beatIndex];
  console.log(circleSynth);

  circleSynth.trigger();

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