// //////////////////////Create Web Audio Context///////////////////////

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

////////////// Web Audio Functions called by Processing //////////////


var masterGain = context.createGain();
masterGain.gain.value = 0.8;
masterGain.connect(context.destination);

// Create a compressor node
var compressor = context.createDynamicsCompressor();
compressor.threshold.value = -24;
compressor.knee.value = 0;
compressor.ratio.value = 20;
compressor.reduction.value = -20;
compressor.attack.value = 0.0001;
compressor.release.value = 0.25;
compressor.connect(masterGain);


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

    cancelTime = 0.01;
    attackTime = 0.05;
    decayTime = 0.1;
    this.vca.gain.cancelScheduledValues(now);


   
    console.log(this);
    this.vca.gain.linearRampToValueAtTime(0, now + cancelTime);
    this.vca.gain.linearRampToValueAtTime(0.6, now + cancelTime + attackTime);
    this.vca.gain.linearRampToValueAtTime(0, now + cancelTime + attackTime + decayTime);
    
  };

  return Voice;
})(context);



function makeBeatSynth(radius, circleIndex, beatIndex) {
  var frequency = 2 * radius;
  var voice     = new Voice(frequency);

  if (!voiceBank[circleIndex]) {
    voiceBank[circleIndex] = {};
  }
  voiceBank[circleIndex][beatIndex] = voice;
  voice.start();
}

function attack(circleIndex, beatIndex) {
  var circleSynth = voiceBank[circleIndex][beatIndex];

  circleSynth.trigger();

}


///////////// Other JS functions called by Processing ///////////////////

function displayRadius(rad, x, y) {
  // add the newly created element and its content into the DOM 
  var currentDiv = document.getElementById("cursorTip"); 
  currentDiv.style.display = 'inline';
  currentDiv.innerHTML = rad;
  currentDiv.style.left = x + 'px';
  currentDiv.style.top = y + 'px';
}

function removeRadDisplay() {
  console.log("mouseup");
  var currentDiv = document.getElementById("cursorTip");
  currentDiv.style.display = 'none';

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