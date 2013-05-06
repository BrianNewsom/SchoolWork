{ SinOsc.ar(200, 0, 0.5) }.play;

// modulate freq
{ SinOsc.ar(XLine.kr(2000, 200), 0, 0.5) }.play;

// modulate freq
{ SinOsc.ar(SinOsc.ar(XLine.kr(1, 1000, 9), 0, 200, 800), 0, 0.25) }.play;

// modulate phase
{ SinOsc.ar(800, SinOsc.ar(XLine.kr(1, 1000, 9), 0, 2pi), 0.25) }.play;

// modulate freq based on Mouse position
{SinOsc.ar(MouseX.kr(20,500))}.play;

