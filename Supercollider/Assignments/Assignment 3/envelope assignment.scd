s.makeWindow.boot;

/*

MUSC 4121_5121

Assignment 3 - push-play with envelopes

From a single multi-enveloped SuperCollider patch, compose a piece of one, two, three, or more, minutes in length. You may use existing patches or create them all from scratch. You will turn in your patch on the due date and they will be performed in class on that day.

DUE: Thursday, March 7
Below is an example of how to create a short piece using envelopes to control and mul arguments of several patches added together to create a composition.

*/

//"easy" example

(

{
var sine, tri, pulse1, pulse2;

a = Env.new([0, 0.5, 0.5, 0], //env for sine
			[5, 10, 5],
			[0, 0, 0]); //Leave blank for linear

b = Env.new([0, 0, 0.5, 0.5, 0], //env for tri
			[10, 5, 5, 5],
			[0, 0, 0, 0]);

c = Env.new([0, 0, 0.5, 0.5, 0], //env for pulse1
			[15, 5, 5, 5],
			[0, 0, 0, 0]);

d = Env.new([0, 0, 0.5, 0.5, 0], //env for pulse2
			[20, 5, 5, 5],
			[0, 0, 0, 0]);

sine =  {SinOsc.ar(200, 0, EnvGen.kr(a), 0)};

tri = {LFTri.ar(220, 0, EnvGen.kr(b), 0)};

pulse1 = {Pulse.ar(240, 0.5, EnvGen.kr(c), 0)};

 pulse2 = {Pulse.ar(190, (FSinOsc.kr(0.1,0.9)), EnvGen.kr(d, doneAction: 2), 0)};

 sine +  tri + pulse1 + pulse2
 }.play

 )

 //same patch, add panning with Pan2

(

{
var sine, tri, pulse1, pulse2;

a = Env.new([0, 0.5, 0.5, 0],
			[5, 10, 5], //Only lasts 20 seconds
			[0, 0, 0]);

b = Env.new([0, 0, 0.5, 0.5, 0],
			[10, 5, 5, 5],
			[0, 0, 0, 0]);

c = Env.new([0, 0, 0.5, 0.5, 0],
			[15, 5, 5, 5],
			[0, 0, 0, 0]);

d = Env.new([0, 0, 0.5, 0.5, 0],
			[20, 5, 5, 5],
			[0, 0, 0, 0]);

sine =  {SinOsc.ar(200, 0, EnvGen.kr(a), 0)};

tri = {LFTri.ar(220, 0, EnvGen.kr(b), 0)};

pulse1 = {Pulse.ar(240, 0.5, EnvGen.kr(c), 0)};

pulse2 = {Pulse.ar(190, (FSinOsc.kr(0.1,0.9)), EnvGen.kr(d, doneAction: 2), 0)}; //Kills the synth ONLY IN LAST ONE - are in same node, so if they have individual doneActions, must be individual synthdef  Not totally necessary

Pan2.ar(sine +  tri + pulse1 + pulse2, SinOsc.kr(2), 1)

 }.play

 )

//A more complex example

//Original patch

(
{
	var exc, amp;
	amp = LFPulse.kr(4,0,0.1,0.002);
	exc = LPZ1.ar(GrayNoise.ar([amp,amp]));
	Klank.ar(`[FloatArray.fill(4, { rrand(80.0,400.0) }),
			nil,
			FloatArray[1, 1, 1, 1]], exc);
}.play;
)

//add an envelope to change the drum speed THIS IS GOOD

(
{
	var exc, amp, rate;  //rate of the beat
	rate = Env.new([1, 8, 2, 12, 3], //levels
					 [3, 5, 4, 5],     //times
					 [0, 0, 0, 0]);    //curve

	amp = LFPulse.kr(EnvGen.kr(rate),0,0.1,0.002); //change the beat speed here
	exc = LPZ1.ar(GrayNoise.ar([amp,amp]));
	Klank.ar(`[FloatArray.fill(4, { rrand(80.0,400.0) }),
			nil,
			FloatArray[1, 1, 1, 1]], exc);
}.play;
)

//add an overall volume envelope

(
{
	var exc, amp, rate, vol;
	rate = Env.new([1, 8, 2, 12, 3],
					 [3, 5, 4, 5],
					 [0, 0, 0, 0]);

	vol = Env.new([0, 0.8, 0.8, 0], //volume levels
					 [1, 15, 4],
					 [0, 0, 0]);
	amp = LFPulse.kr(EnvGen.kr(rate),0,0.1,0.002);
	exc = LPZ1.ar(GrayNoise.ar([amp,amp]));
	Klank.ar(`[FloatArray.fill(4, { rrand(80.0,400.0) }),
			nil,
			FloatArray[1, 1, 1, 1]], exc * EnvGen.kr(vol, doneAction:2)); //multiply by the vol figure out where to plug this in
	//Put mouse x into places until it is mull
}.play;
)



/*
A more complex example extolling Carter Pann's Birthday
*/

(

{
var totalInst, totalPartials, baseFreq, ampControl, chimes, cavern, zap, bif, bam, beat1, beat2;
totalInst = 5; //Total number of chimes
totalPartials = 12; //Number of partials in each chime
baseFreq = rrand(200, 1000); //Base frequency for chimes

e = Env.new([0, 1, 1, 0],
			[5, 60, 5],
			[0, 0, 0]);
k = Env.new([0, 1, 1, 0],
			[5, 60, 5],
			[0, 0, 0]);
f = Env.new([0, 1, 1, 0],
			[10, 60, 5],
			[0, 0, 0]);
g = Env.new([0 ,1, 1, 0],
			[20, 60, 5],
			[0, 0, 0]);
h = Env.new([0 ,1, 1, 0],
			[30, 60, 5],
			[0, 0, 0]);
i = Env.new([0 ,0.2, 0.2, 0, 0, 0.2, 0.2, 0],
			[2, 10, 5, 38, 10, 20, 10],
			[0, 0, 0, 0, 0, 0, 0]);
j = Env.new([0 ,0.2, 0.2, 0, 0, 0.2, 0.2, 0],
			[2, 10, 5, 38, 10, 20, 15],
			[0, 0, 0, 0, 0, 0, 0]);


chimes =
	Mix.ar(
		{
		Pan2.ar(
			Klank.ar(`[
				{baseFreq*rrand(1.0, 12.0)}.dup(totalPartials),
				Array.rand(totalPartials, 0.3, 0.9),
				Array.rand(totalPartials, 0.5, 6.0)],
				Decay.ar(
					Dust.ar(0.2, 0.02), //Times per second, amp
					0.001, //decay rate
					PinkNoise.ar(EnvGen.kr(e)) //Noise
				)), 1.0.rand2) //Pan position
		}.dup(totalInst)
	);

cavern =
	Mix.ar(
		{
		var base;
		base = exprand(50, 500);
			Klank.ar(
				`[ //frequency, amplitudes, and decays
					{rrand(1, 24) * base *
						rrand(1.0, 1.1)}.dup(totalPartials),
					Array.rand(10, 1.0, 5.0).normalizeSum
				],
				GrayNoise.ar( [rrand(0.03, 0.1), rrand(0.03, 0.1)]
										*EnvGen.kr(k))
			)*max(0, LFNoise1.kr(3/rrand(5, 20), mul: 0.005))
		}.dup(5));

zap =
	Mix.ar(
		{
		var base;
		base = exprand(40, 100);
		Pan2.ar(
			Klank.ar(
				`[ //frequency, amplitudes, and decays
					{rrand(1, 24) * base *
						rrand(1.0, 1.1)}.dup(totalPartials),
					Array.rand(10, 1.0, 5.0).normalizeSum
				],
				GrayNoise.ar( rrand(0.03, 0.1)*EnvGen.kr(f))
			)*max(0, LFNoise1.kr(6, mul: 0.005)),
			LFNoise0.kr(1))
		}.dup(5));

bif =
	Mix.ar(
		{
		var base;
		base = exprand(50, 10000);
		Pan2.ar(
			Klank.ar(
				`[ //frequency, amplitudes, and decays
					{rrand(1, 24) * base *
						rrand(1.0, 1.1)}.dup(totalPartials/3),
					Array.rand(10, 1.0, 5.0).normalizeSum
				],
				GrayNoise.ar( rrand(0.03, 0.1)*EnvGen.kr(g))
			)*max(0, SinOsc.kr(6/rrand(1, 10), mul: 0.005)),
			LFNoise1.kr(1))
		}.dup(8));

bam =
	Mix.ar(
		{
		var base;
		base = exprand(50, 100);
		Pan2.ar(
			Klank.ar(
				`[ //frequency, amplitudes, and decays
					{rrand(1, 24) * base *
						rrand(1.0, 1.1)}.dup(totalPartials/4),
					Array.rand(10, 1.0, 5.0).normalizeSum
				],
				GrayNoise.ar( rrand(0.03, 0.1)*EnvGen.kr(h))
			)*max(0, SinOsc.kr(10/rrand(1, 5), mul: 0.005)),
			LFNoise1.kr(1))
		}.dup(8)) * max(0, LFNoise1.kr(1/10)*EnvGen.kr(h));

beat1 =
	{
	var exc, amp;
	amp = LFPulse.kr(XLine.ar(1, 4, 8) ,0,0.1,0.002);
	exc = LPZ1.ar(GrayNoise.ar([amp,amp]));
	Klank.ar(`[FloatArray.fill(4, { rrand(80.0,400.0) }),
			nil,
			FloatArray[1, 1, 1, 1]], exc*EnvGen.kr(i));
	};

beat2 =
	{
	var exc, amp;
	amp = LFPulse.kr(XLine.ar(1, 8, 8),0,0.1,0.002);
	exc = LPZ1.ar(GrayNoise.ar([amp,amp]));
	Klank.ar(`[FloatArray.fill(4, { rrand(80.0,400.0) }),
			nil,
			FloatArray[1, 1, 1, 1]], exc*EnvGen.kr(j, doneAction: 2)).abs;
	};

LeakDC.ar(chimes + cavern + zap + bif + bam + beat1 + beat2); //Prevents DC offset from piling too may on top of each other KR isn't fine tuned. AR is narrower
}.play

)

/*
Note the addition of LeakDC. This is to prevent a DC offset that can happen
when adding a lot of synths together.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Envelope Clarification from H. James Harkins

Note:
An envelope consists of a number of "segments." A segment is
defined as a target value, the amount of time to
reach the target value, and the shape or curve.

This definition of an envelope segment deliberately does not include
the segment's starting value. This is because an envelope segment
always begins with the envelope generator's current value. This is
necessary to prevent discontinuities in the output signal when an
envelope jumps to its releaseNode or loopNode, or it's retriggered
by EnvGen's 'gate' argument.

Consider a simple attack-sustain-release envelope:

EnvGen.kr(Env.asr(1, 1, 1), gate)

Suppose the 'gate' is open (nonzero) for 0.5 seconds.
Assuming linear envelope segments, the envelope
generator would output 0.5 at the time the envelope
should start to release. But the sustain level is 1.0.
What should the EnvGen do? Should it jump suddenly to
1.0 before decaying to 0? Or should the release
actually transition from the current value 0.5 to 0?

Obviously the latter is more generally acceptable. Consequently,
it does not make sense to think of astarting value for an envelope
segment, because the starting value should depend on the current value.

At an EnvGen's beginning, there is no current value. So where
should the envelope start? That value comesfrom the first item in
the 'levels' array. This is why an envelope with /n/ segments will have /n/ items for
'times', but /n+1/ 'levels'.

Env(
	levels: [envgen_init_value, segment0_target, segment1_target...],
	times: [segment0_time, segment1_time...]
)

=Retriggering=

Retriggering causes the EnvGen to jump to segment0 in the above example.
As noted, segment0 consists of itstarget value, time and curve shape.
The envelope generator will transition from its current value toward segment0_target.

IMPORTANT: This means retriggering an envelope will never go back to the envelope's
initial value! That initial value is used exactly once: when EnvGen begins.

// wrong
EnvGen.kr(Env([0, 1], [0.1]), Impulse.kr(2))

When this EnvGen retriggers, it will transition toward the target level 1.
From which level? From the current value, which is also 1. So it will sound like
the envelope is not retriggered at all. In fact, it is --it's just that the envelope
segment being triggered is flat.

To make the retrigger audible, you must provide an envelope segment whose target value is 0.

// right
EnvGen.kr(Env([0, 0, 1], [0.01, 0.1]), Impulse.kr(2))

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

UGen Done Actions

A number of UGens implement doneActions. These allow one to optionally free or pause the enclosing synth and other related nodes when the UGen is finished. These include EnvGen, Line, XLine, Linen, DetectSilence, PlayBuf, Duty, TDuty and Demand.

For a list, see:  Synth-Controlling-UGens

The available done actions are as follows:

0	do nothing when the UGen is finished
1	pause the enclosing synth, but do not free it
2	free the enclosing synth
3	free both this synth and the preceding node
4	free both this synth and the following node
5	free this synth; if the preceding node is a group then do g_freeAll on it, else free it
6	free this synth; if the following node is a group then do g_freeAll on it, else free it
7	free this synth and all preceding nodes in this group
8	free this synth and all following nodes in this group
9	free this synth and pause the preceding node
10	free this synth and pause the following node
11	free this synth and if the preceding node is a group then do g_deepFree on it, else free it
12	free this synth and if the following node is a group then do g_deepFree on it, else free it
13	free this synth and all other nodes in this group (before and after)
14	free the enclosing group and all nodes within it (including this synth)

For information on freeAll and deepFree, see Group and Server-Command-Reference.



*/


