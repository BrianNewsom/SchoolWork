/*

MUSC 4121_5121
SuperCollider assignment 2

Create at three or more SynthDefs with at least one settable argument in each one.
Trigger your synths in sequence (or all together) and change parameters as they play
using the .set message.

The compositions will be performed in class on Tuesday, February 19th.


Below is an example of a cheap composition using stolen examples.
*/


(
///////synth 1

SynthDef( "synth1",
{
arg triggerSpeed = 8, delayTime = 0.0, mix = 0.0, roomSize = 0.0, lowEnd = 40, highEnd = 140,vol = 0.1;
var  trigger, in1, in2, in3, out;
trigger = Impulse.kr(triggerSpeed);
in1 = Pulse.ar(
 		TRand.kr(lowEnd, highEnd, trigger),
 			mul: EnvGen.kr(
  			Env.perc(0.001, 1/triggerSpeed),
  		trigger
 		));
in2 = Pan2.ar(in1,
		FSinOsc.kr(triggerSpeed),
		1);
in3 = CombL.ar(in2, 5, delayTime, 4.5, vol);
out = FreeVerb.ar(in3, mix, roomSize, vol);
Out.ar([0, 1], out)
}).send(s);

////////synth 2

SynthDef("synth2",
{
arg freq = 200, index = 0, offset = 440, mul = 0.3;
x = SinOsc.ar(SinOsc.kr(freq, 0, index, offset), 0, mul, 0);
Out.ar([0, 1], x);
}).send(s);

///////synth 3

SynthDef("synth3",
{
	arg speed = 4, vol = 0.5;
	var exc, amp;
	amp = LFPulse.kr(speed,0,0.1,0.002);
	exc = LPZ1.ar(GrayNoise.ar([amp,amp]*vol));
	y = Klank.ar(`[FloatArray.fill(4, { rrand(80.0,400.0) }),
			nil,
			FloatArray[1, 1, 1, 1]], exc);
	Out.ar([0, 1], y);
}).send(s);

)

//////////trigger the synths

a = Synth("synth1", [\triggerSpeed, 2, \delayTime, 0, \mix, 0, \roomSize, 0, \lowEnd, 40,\highEnd, 120]);
a.set(\vol, 0.5);
a.set(\triggerSpeed, 8);
a.set(\mix, 0.4, \roomSize, 0.4);
a.free;

b = Synth("synth2");
b.set(\index, 400);
b.free;

c = Synth("synth3");
c.set(\vol, 0.5, \speed, 8);
c.free;

//trigger all at once

a = Synth("synth1"); b = Synth("synth2"); c = Synth("synth3");
a.set(\triggerSpeed, 2, \mix, 0.5, \roomSize, 0.4); b.set(\index, 300, \mul, 0.1); c.set(\speed, 8);
b.free;
c.free;
b = Synth("synth2", [\freq, 330, \index, 500, \offset, 600, \mul, 0.01]);
b.free; a.set(\triggerSpeed, 16);
a.free;
