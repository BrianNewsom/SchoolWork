s.makeWindow.boot;

/*
Live Audio Processing Tutorial

One of my compositional interests is in live perfromance with real-time DSP
processing of accoustic instruments. This can add all kinds of possibilities
and dimensions to a perfromance as well as transforming an instrument (an
instrument can be any acoustic sound source, such as a flute, a guitar, car keys,
voices, etc.) The transformation can be subtle, a little bit of reverb or echo, just
enough to enhance the acoustical environment of the perfromance. It can also
be a profound transformation, completely changing the original instrument into
a kind of "meta-instrument" that no longer has the original sonic characteristics
or performance limitations.

To process a signal you will need a UGen that has an in argument. Most of the
SC filters, and many other UGens, will have an in argument. The UGen that will
send a signal into the in is SoundIn.

SoundIn			read audio from hardware inputs

SoundIn.ar(bus, mul, add)

SoundIn is a convenience UGen to read audio from the input of your computer or soundcard.
It is a wrapper UGen based on In, which offsets the index such that 0 will always correspond
to the first input regardless of the number of inputs present.
bus - the channel (or array of channels) to read in. These start at 0, which will
          correspond to the first audio input.




The first step to sending a signal into SC is to make sure you have an input source
set in your System Preferences. This in put source can be any extrenal audio interface,
in the case of the CAML labs it would be the Mbox or bult in mic.
*/

//////////audio in test
(
{ SoundIn.ar(0) }.scope(1);	// check the input
)

/*
The next patches use RecordBuf to record into a buffer.
Here is a simple looper.
*/


d = Buffer.alloc(s, 44100 * 4.0, 2); // a four second 1 channel Buffer

{RecordBuf.ar(SoundIn.ar([0,1]), d.bufnum, loop: 0)}.play;

{PlayBuf.ar(2, d.bufnum, loop: 1)}.play(s);

(// accelerate the loop playback
 {
	var rate;
	rate = XLine.kr(0.1,1000,60);
	Out.ar([0,1],
		PlayBuf.ar(1, d.bufnum, rate, 1.0,0.0, 1.0)
	)
}.play;
)



//Splitting a 1 channel input into a stereo pair

(
{
var signal;
signal = SoundIn.ar(0);

Pan2.ar(signal, 0, 0.5)
}.scope
)

//Add some reverb

(
{
var signal, pan;
signal = SoundIn.ar(0);
pan = Pan2.ar(signal, 0, 0.5);

FreeVerb.ar(pan, 0.5, 0.5, 0.7, 0.5);
}.scope
)

//Add a delay


(
{
var signal, pan, reverb;
signal = SoundIn.ar(0);
pan = Pan2.ar(signal, 0, 0.5);
reverb = FreeVerb.ar(pan, 0.5, 0.5, 0.7, 0.5);

CombL.ar(reverb, 3, 0.1, 8, 0.5)

}.scope
)

//try different values
(
{
var signal, pan, reverb;
signal = SoundIn.ar(0);
pan = Pan2.ar(signal, 0, 0.5);
reverb = FreeVerb.ar(pan, 0.2, 0.2, 0.3, 0.5);

CombL.ar(reverb, 1, 3, 8, 0.5)

}.scope
)


//Add MouseX to mess with your head

(
{
var signal, pan, reverb;
signal = SoundIn.ar(0);
pan = Pan2.ar(signal, 0, 0.5);
reverb = FreeVerb.ar(pan, 0.5, 0.5, 0.7, 0.5);

CombL.ar(reverb, 6, MouseX.kr(0, 3).poll, 20, 5)

}.scope
)

/*
The following patch is an example of a performance piece originally
written for viola and SC. In performance, the violist will start SC
and then begin playing. A clock on the monitor will give the performer
a reference to where they should be in the score as they perform the piece.



  The View From Dead Horse Point - A fanatasy for solo viola and computer
  John Drumheller
  for Erika Eckert
 (ver. SC3 2/15, clock)
  Boot the local and internal servers.
  To start patch, double click after top parens
*/

(
var window, starttime, task;

 window = Window("Dead Horse Point - elapsed time", Rect(200, 662, 520, 180));

 starttime = Main.elapsedTime;

// The clock
StaticText(window, Rect(10,4,240,100))
         .string_(starttime.round(0.01).asString);
 window.view.children[0].font = Font(\Helvetica,82);


 window.front;

 task = Task({
         inf.do{
                 var time, secs;
                 time = (Main.elapsedTime - starttime);
                 secs = (time mod: 60).round(0.1);
                 (secs < 10).if({secs = "0"++secs});
                 {window.view.children[0].string_(""++(time div:60) ++":"++secs)}.defer;
                 0.1.wait;
                 }
         }, SystemClock);

 task.play;




{
var e, r, in, m, x;

e = Env.new(
		[6.0, 0.07, 0.09, 2.0, 0.01, 6.0],
		[35, 130, 50, 80, 130],
		[-3.9, 1.9, 0.99, 5.9, 2.9]);
r = Env.new(
		[1, 2, 5, 2, 1, 5, 1],
		[110, 30, 30, 160, 40, 30],
		[0, -5.0, 2.9,-2.9, -0.9, 0.9]);
x = Env.linen(2,500,20);			//trapazoidal Envelope for input,wrap input around form
in = SoundIn.ar(0, 1.4) * SinOsc.ar(m = EnvGen.kr(r), [0,0.5pi])* EnvGen.kr(x);
	Limiter.ar(				//amplitude input control
		CombL.ar(
			in,
			6.0, 				// max delay time
			m = EnvGen.kr(e),    // delay time
			20,				// echo 60 dB decay time in seconds
			5, 				// scale by unity
			in * EnvGen.kr(x)	// mix with input
		),
	0.99, 0.01)				//Limiter args
}.scope(2);

)


/*
Pitch  and ampitude following using Pitch.kr
and Amplitude.kr

These patches first define a synth and then use the .set message
to change the delayTime of a Comb filter.
*/

(
SynthDef("echoLoop",
{
	arg delay = 6, delaytime = 6;
	var in, amp, freq, hasFreq, out;
	in = Mix.new(SoundIn.ar(0));
	amp = Amplitude.kr(in, 0.05, 0.05);
	# freq, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 7);
	//freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
	out = Mix.new(VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp));

	out = CombN.ar(out, delay, delaytime, 599, 1, out);

	6.do({
		out = AllpassN.ar(out, 0.040, [0.040.rand,0.040.rand], 2)
	});
	Out.ar(0,out)
}).add;
)

a = Synth("echoLoop");

a.set(\delaytime, 3);

a.set(\delaytime, 0.5);

a.set(\delaytime, 6);

a.free;


///////////////////////
(
SynthDef("echoLoop1",
{
	arg delay = 6, delaytime = 0.5;
	var in, amp, freq, hasFreq, out;
	in = Mix.new(AudioIn.ar([1,2]));
	amp = Amplitude.kr(in, 0.05, 0.05);
	# freq, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 7);
	//freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
	out = Mix.new(VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp));

	out = CombN.ar(out, delay, delaytime, 599, 1, out);

	6.do({
		out = AllpassN.ar(out, 0.040, [0.040.rand,0.040.rand], 2)
	});
	Out.ar(0,out)
}).add;
)

a = Synth("echoLoop1");

a.set(\delaytime, 1);

a.set(\delaytime, 2);

a.set(\delaytime, 4);

a.set(\delaytime, 6);

a.free;


////////////////////

(
SynthDef("echoLoop2",
{
	arg delay = 6, delaytime = 0.5;
	var in, amp, freq, hasFreq, out;
	in = Mix.new(AudioIn.ar([1,2]));
	amp = Amplitude.kr(in, 0.05, 0.05);
	# freq, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 7);
	//freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
	out = Mix.new(VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp));

	out = CombN.ar(out, delay, delaytime, 599, 1, out);

	6.do({
		out = AllpassN.ar(out, 0.040, [0.040.rand,0.040.rand], 2)
	});
	Out.ar(0,out)
}).add);
)

a = Synth("echoLoop2");

a.set(\delaytime, 1);

a.set(\delaytime, 2);

a.set(\delaytime, 4);

a.set(\delaytime, 6);

a.free;

b = Synth("echoLoop2");

b.set(\delaytime, 1);

b.set(\delaytime, 2);

b.set(\delaytime, 4);

b.set(\delaytime, 6);

b.free;

///////////GRANULTE ME BABY! - patch for BLOrk

(
SynthDef("grainshift",
{var grainSize;
grainSize = 3.5;

	y= PitchShift.ar(
		SoundIn.ar([0,1]),
		grainSize,
		1,						// nominal pitch rate = 1
		MouseX.kr(0,1).poll(1), 			// pitch dispersion
		MouseY.kr(0, grainSize).poll(1),	// time dispersion
		1.0
	);

y = FreeVerb.ar(y, 0.5, 0.5, 0.4, 0.9);

Out.ar([0, 1, 2, 3, 4, 5], y)
}).play
 )





//THINK OF PROPOSAL FOR NEXT CLASS