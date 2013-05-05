s.makeWindow.boot;

/*
Tutorial 14

Patterns, and an introduction to algorithmic composition

Pbind, Pseq, etc

Pbind

Pbind links together different parameters of musical events. It streams those values using a
pattern to the current Environment. The Environment is another behind the scenes structure
we haven't worried about until now. It contains a group of global default values attached to
symbols. Below is an incomplete list. You will notice that they are often the same value
expressed in different ways: freq and midinote, amp and db.

\amp = 0.1, \db = -20, \degree = 0, \dur = 1, \freq = 261.62, \legato = 0.8, \midinote = 60,
\note = 0, \octave = 5, \out = 0, \pan = 0, \root = 0, \scale = [0, 2, 4, 5, 7, 9, 11], \server =
default, \velocity = 64, \instrument = default, \out = 0, \group = 0

You pass values to the environment with Pbind by matching a symbol (e.g. \freq) with the
value (e.g. 400) or a function that returns a value (e.g. rrand(400, 900)). If none is supplied,
then it uses defaults. The defaults are useful because they allow you to focus on one or two
elements of composition. If you just want to experiment with pitch you don't have to specify
amplitude, duration, instrument, etc: It will use the defaults.


We'll work backwards! We'll start with what seems magical then explain some of how it works.
Patterns require some effort to understand properly, but the good news is that you can use
their power without needing to go very far into the implementation.
*/



// run this line
a = Pbind.new.play;

a.stop;		// Or stop it with cmd+period;

// now run this line
Pbind(\freq, 440).play;

(
Pbind(
	\freq, 880		// change to another number!
).play;
)

/*
It becomes more interesting when you use other streaming processes. The first example
shows a Pfunc that evaluates any function, in this case random values for pitch. The second
adds duration. The third passes midi pitches by way of the symbols \degree and \octave.
Degree is a scale degree, octave is the octave, where 5 is the C4 octave.
*/

Pbind(\freq, Pfunc({rrand(100, 900)})).play;

(
Pbind(
	\freq, Pfunc({rrand(100, 900)}),
	\dur, Pfunc({rrand(0.1, 1.5)})).play
)

(
Pbind( //Fun
	\degree, Pfunc({8.rand}),
	\oct, Pfunc({rrand(3, 7)}), //or try \octave?
	\dur, 0.2).play
)

(
Pbind(
	\scale, [0, 2, 4, 6, 8, 10],
	\degree, Pfunc({6.rand}),
	\oct, Pfunc({rrand(3, 7)}), //or try \octave
	\dur, 0.2).play
)

(
Pbind(
	\scale, [0, 2, 3, 5, 6, 8, 10, 11],
	\degree, Pfunc({8.rand}),
	\oct, Pfunc({rrand(3, 7)}), //or try \octave
	\dur, 0.2).play
)


/*
All of the instruments you've designed that are in the SynthDef folder are available in the
 environment. All of the arguments that you created in conjunction with those instruments
 are symbols that can be matched to values. If you happened to have used arguments
 like midinote, then they will fit right into the existing Environment. If you named them
 something else, such as midiPitch and art for articulation, you just need to use those symbols.
*/
(
SynthDef.new("KSpluck3",
	{ //Beginning of Ugen function
	arg midiPitch, art;
	var burstEnv, att = 0, dec = 0.01, legalPitches; //Variable declarations
	var out, delayTime;
	delayTime = [midiPitch, midiPitch + 12].midicps.reciprocal;
	burstEnv = EnvGen.kr(Env.perc(att, dec));
	out = PinkNoise.ar([burstEnv, burstEnv]); //Noise burst
	out = CombL.ar(out, delayTime, delayTime,
		art, add: out); //Echo chamber
	out = RLPF.ar(out, LFNoise1.kr(2, 2000, 2100), 0.1); //Filter
	DetectSilence.ar(out, doneAction:2);
	Out.ar(0, out*0.8)
	}
).play;
)



(
Pbind(
 \instrument, "KSpluck3",
 \midiPitch, Pfunc({rrand(34, 72)}),
 \art, Pfunc({rrand(1.0, 2.0)}),
 \dur, 0.1
).play
)


/*
What happens here is that the Pbind class allows you to match properties of a
sound event to your provided parameter values.
*/

(
Pbind(
	\freq, Pseq([440, 660, 990, 880, 770],inf)   // try a different list
).play;
)

/*
The Pseq is an example of a Pattern, which can be thought of as
generating a sequence of values

440, 660, 990, 880, 770, 440, 660, 990, ...

returning the next one in the sequence each time it is evaluated
run this, go back and run some of the others at the same time
*/

(
Pbind( //fun
	\dur,0.125,
	\midinote, Pseq([0, 4, 0, 7, 4, 0, 0] + 60,inf),
	\amp, Prand([0.125, 0.2, 0.25],inf)
).play
)

/*
There are many useful types of Pattern class to try. Here are some specific examples:
*/


// loops through the sequence of the array, perpetually:
Pseq([0,1,2,3],inf)

// next value is a random member of the array, after 5 times stop:
Prand([0,1,2,3],5)

// next value is a random member of the array
// except you can't repeat the previous value:
Pxrand([0,1,2,3],inf)

// next value is a weighted choice from the first array
// using the weights given in the second argument.
// After returning one value, stop:

Pwrand([0,1,2,3], [0.5,0.3,0.1,0.1], 1)

// next value is the result of evaluating the
// given function, in this case 4.rand:
Pfunc({ 4.rand })

/*
There are many Patterns types to explore; a good starting point is the following help file:
*/

[Streams]	// select the text within the box then cmd-d

/*
Patterns are generators for streams. An example of a stream is the routine (see scheduling)
for this, "asStream" is used:
*/

(
var a, x;
a = Pseq([1, 3, 400]);
x = a.asStream;
x.next.postln;
x.next.postln;
x.next.postln;
)


// this means that from one pattern one can generate many independent
//streams:

(
var a, x, y;

a = Pshuf([1, 2, 3], inf);
x = a.asStream;	// this creates a routine from the pattern.
y = a.asStream;
x.nextN(10).postln;
y.nextN(10);
)


// a sound example:

(
var a =  Pshuf([1, 1, 0, 1, 0], 3);
Pbind(
	\dur, 0.125,
	\midinote, a * 7 + 60,
	\amp, a * 0.1
).play
)

// Patterns can be built of arbitrary complexity by nesting -

Pseq([Pseq([100, 200, 300], 2), 400, 500, 600], inf);

// Examples of nested Patterns

(
Pbind(
	\freq, Pseq([Pseq([100, 200, 300], 2), 400, 500, 600],inf)
).play;
)


(
Pbind(
	\freq, Pseq([Prand([440, 442, 445, 448]), Pxrand([840, 741, 642], 2)], inf)
// Pxrand never repeats the same value from the array twice in a row
).play;
)



// Note how we get one random value from the first array,
// followed by two different values from the second.
(
	a = Pseq([Prand([440, 442, 445, 448]), Pxrand([840, 741, 642], 2)],inf).asStream;
	20.do({a.next.postln;});
)


/*
To get back to Pbind, there's stuff going on behind the scenes, which SuperCollider is doing for you...
Let's bring some of the hidden variables into view!
*/

(
var clock;

clock = TempoClock(1.5); // tempoclock at 90 bpm

Pbind(
	\freq, Pseq([440, 660, 990, 880, 770], inf),	// frequency in hertz
	\dur, Pseq([1.0, 0.5, 0.25, 0.25],inf),				// duration of event in beats
	\legato, 0.5,	// proportion of inter onset time to play
	\pan, Pseq([0.5, -0.5],inf),
	\instrument, \default
).play(clock);
)

/*
There is a distinction between the duration of this event and the duration until next
event. The default \dur in the Pbind is used as both, but really means the time until the next
event. The actual duration of this event is determined by legato, which is a percentage of dur.
The default is 0.8.  For example, given a duration (time until next event) of 4 the actual duration of this
event would be 0.8*4 or 3.2. So legato could be used for actual duration (2.5 legato + 4
duration = 10 actual duration).


The Pbind class always takes pairs of arguments, a literal \property and an associated Pattern
(or value, or stream) that returns the values to be tied to that Pbind.

You can see the default properties by looking at the defaults defined there.

You can define your own properties, and have the values passed directly to your own synthesis function.

*/

// run me first
(
SynthDef(\alicepavelinstr, {arg out=0, alice=440, pavel=0.5, pan=0.0, gate=1;
			var z;
			z = Pulse.ar(alice, pavel) * Linen.kr(gate, 0.01, 0.1, 0.3, 2);
			Out.ar(out, Pan2.ar(z, pan));
			 }
).add
)

(
var clock;

clock = TempoClock(1.5); // tempoclock at 90 bpm

Pbind(
	\alice, Pseq([440,660,990,880,770],inf),   // freq
	\pavel, Pseq([0.1,0.5, 0.8],inf),	// pulse width
	\dur, Pseq([1.0,0.5],inf),			// duration of event in beats
	\legato, 0.5,					// proportion of inter onset time to play
	\instrument, \alicepavelinstr		// your own synthesiser
).play(clock);
)

/*
You might have noticed that all the properties are independent of one another.
What happens if frequency depends on amplitude?
*/

(
Pbind(// cobinding of properties
	[\freq, \amp],
	Pseq([
		[440,0.4],
		[330,0.1],
		Pfuncn({
			[550.rand, 0.8.rand]
		}, 1)
	], inf)
).play
)


// checking already decided properties of the Event that will be performed
// before setting a new value

(
Pbind(
	\freq, Pseq([ 440, 330, Pfuncn({ 550.rand + 40 }, 1)], inf),
	\amp, Pfunc({ arg event;
			event.postln;
			if(event.freq > 350, {
				"here".postln;
				rrand(0.1,0.5);
			}, 0.05);
		})
).play
)

/*
Now we're ready to do some prettier things with Patterns,
by playing multiple simultaneous voices and adding some polyphony
and involvement to the music!
*/


// two simultaneous voices using Ppar
(
	var melodypat, basspat;

	melodypat = Pbind(
			[\midinote, \dur],
			Pseq([
				[60, 0.75],[64, 0.5],[66, 0.5],[69, 0.25],
				[67,0.75],[64,0.5],[60,0.5],[57,0.25]
			])  //Define the melody here
	);

	basspat = Pbind(
			\midinote, Pseq([48, 42], inf),  //define the bass here
			\dur, 1
	);

	Ppar([ melodypat, basspat ]).play(TempoClock(1));
				//put them in a paired pattern here
)


//  Henon map / attractor (returns points in -1.5<x<1.5, -0.4<y<0.4,
//  which are then used for pan (x values) and degrees from
// 2 octave dorian (y values) (Staffan Liljegren)

(
p = Prout({
	var x0, y0, x, y;
	x0 = 0; y0 = 0;
	loop({
		x = y0 + 1 - (1.4 * x0 * x0);
		y = 0.3 * x0;
		x0=x; y0=y;
		[x, (y*14).asInteger].yield;
	});
});

// \degree is the degree of the scale provided in \scale-
// this is where the dorian tuning comes from
b = Pbind(\scale, [0,2,3,5,7,9,10], \dur,0.125,[\pan, \degree], p);
Ptpar([ 0.0, Pbindf(b, \octave, 4,\stretch, 3.0), 4.0, b]).play(TempoClock(1));
)

/*
Pbindf is a filter Pbind - this means it operates on the Pattern b,
adjusting the current properties
of the environment - in this case \octave and \stretch

Note how this allows a slow version of b in the bass and a faster version
higher up coming in after 4 seconds

Note that you can use normal Patterns without Pbind and they are
often extremely useful for quickly generating sequences of values
or algorithmic composition. See the Scheduling tutorial.
*/

(
// run me first-
SynthDef(\pulsepan,{arg freq;
		Out.ar(0,
			Pan2.ar(
				Pulse.ar(freq, Rand(0.4, 0.6), 0.2)
				* XLine.kr(0.001, 1, 0.9, doneAction:2),
				Rand(-1.0, 1.0)
			)
		)
}).add
)


(
var p, t;

p = Pseq([100, 200, 300, 330, 478, Prand([987, 789], 1)],inf).asStream;

t = Routine({
		loop({
			Synth(\pulsepan,[\freq,p.next]); // get next frequency value 												//from pattern
			0.1.wait;
		});
	});
SystemClock.sched(0.0,t)
)


/*
To make a new SynthDef and make sure it is ready for use with Pbind
you use .store rather than .load or .send. this will save a SynthDef file on disk, read it into
the SynthDescLib and send it to the active Server.
*/


(
SynthDef(\nickinstr, { arg out=0, freq=440, amp=0.1, pan=0, gate=1;
			var z;
			z = LPF.ar(
				Mix.ar(LFSaw.ar(freq*[0.99,1,1.01],0.0,amp)),
				XLine.kr(5000, 1000, 1.5))
			* EnvGen.kr(Env.new([0,1,0],[0.01,0.01],\lin,1), gate, doneAction:2);
			Out.ar(out, Pan2.ar(z, pan));
		}).add;
)

/*
You can supply the \out and \gate arguments for controlling
the target audio bus and the release of the Synth after a given
duration. Whether you use gate or not, you should use a doneAction
to release the enclosing Synth at some point to prevent build up
of Synths and eventual overload of the Server.
*/

(
Pbind(
	\dur, 1.25,
	\midinote, Pseq([0,5,0,7,4,0,0]+60,inf),
	\amp, Prand([0.125,0.2,0.25],inf),
	\instrument, Pseq([\nickinstr,\default],inf),
	\pan, Prand([-1,0,1],inf)
).play
)


/*
More Patterns

Pbind is very useful in interpolation; transforming an existing style or pattern with slight
adjustments. First I define a simple instrument with arguments suited to serial studies.
Remember, we aren't concerned with the character of the instrument. Our focus is on pitch,
duration, amplitude, etc. Remember that each time you create a new instrument it's a good idea to
reread the DescLib.
*/

(
SynthDef("SimpleTone",
{arg midinote = 60, amp = 0.9, dur = 1, pan = 0, legato = 0.8;
	Out.ar(0,
		Pan2.ar(
			SinOsc.ar(midinote.midicps, mul: amp)
			*
			EnvGen.kr(Env.perc(0, dur*legato), doneAction: 2),
			pan
	)
	)
}).add;
)

/*
Next is a model that will serve for interpolation studies in pitch. The midinote is determined
by a routine; a function that remembers previous states, such as the counter. The melody is a
Bach invention. If you are familiar with the original I should point out a couple of cheats: the
melody is transposed to a single octave (once we get into the transformations the effect is the
same) and I repeat some notes to dodge the issue if rhythmic values. Likewise, the effect is
the same.

Instead of just entering the MIDI values I use the degree and scale array, which work
together. Scale is the whole/half-step orientation of harmonic minor. Degree is which step of
that scale to use. The advantage of these two combined is that it allows me to change the
mode (e.g. from harmonic minor to Lydian) without having to reenter all the notes from
scratch. The degree array stays the same and I can change the scale.

The degree array is adjusted by –1 only to cater to my musical sense. I would normally
reference the scale array using 0, 1, 2, for scale steps 1, 2, and 3. But typing out or changing
notes in the melody is much easier if I can think in musical terms, that is, 1 is the first step of
the scale, [1, 3, 5] is a tonic arpeggio, [1, 4, 6] is first inversion.
*/
(
var degreeSeq, nextPitch, scale;

scale = [0, 2, 3, 5, 7, 8, 11];

degreeSeq = [1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2,
	3, 3, 5, 5, 1, 1, 4, 4, 7, 7, 2, 2] - 1;


nextPitch = Routine({
	inf.do({arg count;
		scale.wrapAt(degreeSeq.wrapAt(count)).yield;
	})
});

Pbind(
	\instrument, "SimpleTone",
	\midinote, nextPitch + 60,
	\dur, 0.1
	).play
)

/*
Here is where you can satisfy your compositional curiosity with quick answers in terms of
actual playback. What if we played it backward (count.neg)? How about every other pitch
(count*2)? every third, fourth, and so on. How about an inversion (12 – scale.wrap etc.)?
Halved intervals (scale = [etc.]/2), doubled intervals, different modes (scale = [0, 2, 3, 5, 7,
8, 9])? Here are a few more.
*/

// increasing multiples
	var mul = 1;
	inf.do({arg count;
		if(count%20 == 19, {mul = mul + 1});

// occasional random values

	inf.do({arg count;
		if(count%6 == 5, {12.rand.yield},
		{(scale.wrapAt(degreeSeq.wrapAt(count*mul))).yield});

// occasionally dodge sequence

		if(count%6 == 5, {scale.choose.yield},
		{(scale.wrapAt(degreeSeq.wrapAt(count*mul))).yield});

// gradually change scale

		if(count%6 == 5, {scale.put(scale.size.rand, 12.rand)});
		(scale.wrapAt(degreeSeq.wrapAt(count))).yield;

/*
Prand, Pseries, Pseq

There are a dozen or so useful patterns (look in the Streams help file). I'll demonstrate three
here. Prand returns a random choice from an array (see also Pwrand, or weighted random
pattern), Pseries returns a series of values with arguments for start, step, and length. Pseq
seems to be used the most. It steps through an array of values. They can all be nested, as
shown in the last example.
*/
(
f = 100;

Pbind(
	\instrument, "SimpleTone",
	\midinote, Pfunc({
		f = ([3/2, 4/3].choose) * f;
		if(f > 1000, {f = f/8}); //.fold or .wrap didn't do what I wanted
		f.cpsmidi
		}),
	\dur, 0.2
	).play

)

(
Pbind(
	\instrument, "SimpleTone",
	\midinote, Prand([60, 62, 64, 65, 67, 69, 70], inf),
	\dur, 0.1
	).play

)

(
// The dur array is 1s and 2s, representing eighth notes.

Pbind(
	\instrument, "SimpleTone",
	\midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70,
		65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69], inf),
	\dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2,
		2, 1, 1, 1, 1, 2, 2, 2, 2, 2] * 0.2, inf)
	).play
)

/*
And of course, you can run several Pbinds. (Bach would have wanted it that way.) Try 1 or
0.5 as the last dur for 2 and 3. Pbind also responds to mute and unmute. Listen to this
example long enough to hear the phase shift:
*/


(
a = Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70,
  65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2,
  2, 1, 1, 1, 1, 2, 2, 2, 2, 2] * 0.1, inf),
 \pan, -1
 ).play;

b = Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70,
  65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69, 0], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2,
  2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2] * 0.1, inf),
 \pan, 0
 ).play;

c = Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70,
  65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69, 0, 0], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2,
  2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2] * 0.1, inf),
 \pan, 1
 ).play;
)

a.mute;
b.mute;
a.unmute;
c.mute;
b.unmute;
c.unmute;

// Riley?

(

p = Array.fill(20, {[0, 2, 4, 7, 9].choose + [60, 72].choose}).postln;
q = p.copyRange(0, p.size - 2).postln;
Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([Pseq(p), Pseq(p), Pseq(p)], inf),
 \dur, 0.1,
 \pan, -1
 ).play;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([Pseq(p), Pseq(p), Pseq(q)], inf),
 \dur, 0.1,
 \pan, 1
 ).play;
)

// Or gradual phase
(//Play with this

p = Array.fill(20, {[0, 2, 4, 7, 9].choose + [60, 72].choose}).postln;
Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq(p, inf),
 \dur, 0.1,
 \pan, -1
 ).play;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq(p, inf),
 \dur, 0.101,
 \pan, 1
 ).play;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq(p, inf),
 \dur, 0.102,
 \pan, 0
 ).play;
)

/*
Here are some nested patterns. Pbind is a perfect tool for serialization. Below is a 12-tone
example with rhythm partially serialized (mixed with aleatory), and dynamic levels also part
serialized part random.
*/

(

a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
r = [0.1, 0.1, 1.0, 0.2, 0.3, 0.166, 0.166];
o = [48, 60, 72];

Pbind(
 \instrument, "SimpleTone",
  \midinote, Prand(
  [ //P, R, I, IR
   Pseq(a) + o.choose,
   Pseq(a.reverse) + o.choose,
   Pseq(12 - a) + o.choose,
   Pseq((12 - a).reverse) + o.choose
  ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
    Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
    Pseries(0.1, 0.1, 5), // cresc
    Pseries(0.9, -0.1, 6), // decresc
    Prand([0.1, 0.3, 0.5, 0.7], 5)
    ], inf)
).play;
)

(

// And of course, three at once.

// If seed is any number other than 0 that seed will be used.
// If 0, a random seed will be picked and posted. Use it to
// repeat a performance.

var seed = 0;

if(seed !=0, {thisThread.randSeed = seed},
 {thisThread.randSeed = Date.seed.postln});

a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
r = [0.1, 0.1, 1.0, 0.2, 0.3, 0.166, 0.166];
o = [48, 60, 72];

Pbind(
 \instrument, "SimpleTone",
 \pan, -1,
 \midinote, Prand(
  [ //P, R, I, IR
   Pseq(a) + o.choose,
   Pseq(a.reverse) + o.choose,
   Pseq(12 - a) + o.choose,
   Pseq((12 - a).reverse) + o.choose
  ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
    Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
    Pseries(0.1, 0.1, 5), // cresc
    Pseries(0.9, -0.1, 6), // decresc
    Prand([0.1, 0.3, 0.5, 0.7], 5)
    ], inf)
).play;

Pbind(
 \instrument, "SimpleTone",
 \pan, 0,
 \midinote, Prand(
  [ //P, R, I, IR
   Pseq(a) + o.choose,
   Pseq(a.reverse) + o.choose,
   Pseq(12 - a) + o.choose,
   Pseq((12 - a).reverse) + o.choose
  ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
    Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
    Pseries(0.1, 0.1, 5), // cresc
    Pseries(0.9, -0.1, 6), // decresc
    Prand([0.1, 0.3, 0.5, 0.7], 5)
    ], inf)
).play;

Pbind(
 \instrument, "SimpleTone",
 \pan, 1,
 \midinote, Prand(
  [ //P, R, I, IR
   Pseq(a) + o.choose,
   Pseq(a.reverse) + o.choose,
   Pseq(12 - a) + o.choose,
   Pseq((12 - a).reverse) + o.choose
  ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
    Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
    Pseries(0.1, 0.1, 5), // cresc
    Pseries(0.9, -0.1, 6), // decresc
    Prand([0.1, 0.3, 0.5, 0.7], 5)
    ], inf)
).play;

)

////////////////////name this tune

(
//First load the synth and save to disk
SynthDef("bindTest1",
	{
		arg midinote = 60, amp = 0.9, dur = 1, pan = 0, legato = 0.8,
		delayDecay = 3.0;
		var burstEnv, att = 0, dec = 0.001;
		var signalOut, delayTime;
		delayTime = [midinote, midinote + 12].midicps.reciprocal;
		burstEnv = EnvGen.kr(Env.perc(att, dec));
		signalOut = BrownNoise.ar(burstEnv*0.3)+PinkNoise.ar(burstEnv*0.4);
		signalOut = CombL.ar(signalOut, delayTime, delayTime,
			delayDecay, add: signalOut);
		DetectSilence.ar(signalOut, doneAction:2);
		Out.ar(0, signalOut)
	}
).add;
)




//play the tune


(
	var melodypat, basspat;

	melodypat = Pbind( \instrument, "bindTest1",//insert instrument here
			[\midinote, \dur],
			Pseq([
				[57,0.5],[60,0.5],[64,0.5],[69,0.5],
				[71,0.5],[60,0.5],[64,0.5],[71,0.5],
				[72,0.5],[64,0.5],[60,0.5],[72,0.5],
				[66,0.5],[62,0.5],[57,0.5],[66,0.5],
				[64,0.5],[60,0.5],[57,0.5],[60,1],
				[64,0.5],[60,0.5],[57,0.5],
				[55,0.5],[57,0.5],[57,3]
			],inf)
	);

	basspat = Pbind( //default instrument
			[\midinote, \dur],
			Pseq([
				[57, 2],[56, 2],[55,2],[54,2],[53,4],[47, 0.5],
				[45,0.5],[45,0.5],
				[52,0.5],[60,0.5],[59,0.5],[57,0.5],[55,0.5]
				],inf)

	);

	Ppar([ melodypat, basspat ]).play(TempoClock(1));
)

///make a bass and some drums


(
//First load the synth and save to disk
SynthDef("stairWellToHell",
	{
		arg midinote = 60, amp = 0.9, dur = 1, pan = 0, legato = 0.8,
		delayDecay = 5.0;
		var burstEnv, att = 0, dec = 0.001;
		var signalOut, delayTime;
		delayTime = [midinote, midinote + 12].midicps.reciprocal;
		burstEnv = EnvGen.kr(Env.perc(att, dec));
		signalOut = BrownNoise.ar(burstEnv*0.3)+PinkNoise.ar(burstEnv*0.4);
		signalOut = CombL.ar(signalOut, delayTime, delayTime,
			delayDecay, add: signalOut);
		DetectSilence.ar(signalOut, doneAction:2);
		Out.ar(0, signalOut)
	}
).add;


SynthDef("CheapoBass",
{arg midinote = 60, amp = 0.5, dur = 4, pan = 0, legato = 0.8;
	Out.ar(0,
	(Pan2.ar(
			Pulse.ar(midinote.midicps, SinOsc.ar(4, 0, amp, 0.5), 0.3)
			*
			EnvGen.kr(Env.perc(0.1, dur*legato), doneAction: 2),
			pan;
	)))

}).add;



SynthDef("garbageCanLid", //Play with this
{
arg dur = 1, freq = 2820;
a = PinkNoise.ar;
b = BPF.ar(a, freq, 0.2) * EnvGen.kr(Env.perc(0.0, 1, 1, -4),doneAction:2);
e = FreeVerb.ar(b, 0.5, 0.7, 0, 4);
Out.ar([0, 1], e)
}).add

)

//play the tune forever...

(
	var melodypat, basspat, cymbpat;//.flop to make into pairs/back to two ararys
	melodypat = Pbind( \instrument, "stairWellToHell",//insert instrument here
			[\midinote, \dur],
			Pseq([
				[57,0.5],[60,0.5],[64,0.5],[69,0.5],
				[71,0.5],[60,0.5],[64,0.5],[71,0.5],
				[72,0.5],[64,0.5],[60,0.5],[72,0.5],
				[66,0.5],[62,0.5],[57,0.5],[66,0.5],
				[64,0.5],[60,0.5],[57,0.5],[60,1],
				[64,0.5],[60,0.5],[57,0.5],
				[55,0.5],[57,0.5],[57,3]
			],inf)
	);

	basspat = Pbind( \instrument, "CheapoBass",//default instrument
			[\midinote, \dur],
			Pseq([
				[57, 2],[56, 2],[55,2],[54,2],[53,4],[47, 0.5],
				[45,0.5],[45,0.5],
				[52,0.5],[60,0.5],[59,0.5],[57,0.5],[55,0.5]
				],inf)

	);

	cymbpat = Pbind(\instrument, "garbageCanLid",
	[\freq, \dur],
	Pseq([
		[3810, 1], [1800, 1], [810, 0.5], [4800, 0.5],
		[3000, 1], [1700, 0.5], [810, 1], [4200, 0.5],
		[2000, 0.5], [1780, 0.5], [810, 0.5], [14000, 0.5],
		[25, 0.25], [1780, 0.25], [910, 0.25], [3000, 0.25]
		],inf)
		);

	Ppar([ melodypat, basspat, cymbpat ]).play(TempoClock(1));
 )

/*
Using the same SynDefs, this example stores two Ppars in variables and then
plays those variables in a Pseq.
*/

(
	var melodypat, basspat, cymbpat;

	melodypat = Pbind( \instrument, "stairWellToHell",//insert instrument here
			[\midinote, \dur],
			Pseq([
				[57,0.5],[60,0.5],[64,0.5],[69,0.5],
				[71,0.5],[60,0.5],[64,0.5],[71,0.5],
				[72,0.5],[64,0.5],[60,0.5],[72,0.5],
				[66,0.5],[62,0.5],[57,0.5],[66,0.5],
				[64,0.5],[60,0.5],[57,0.5],[60,1],
				[64,0.5],[60,0.5],[57,0.5],
				[55,0.5],[57,0.5],[57,3]
			],1)
	);

	basspat = Pbind( \instrument, "CheapoBass",//default instrument
			[\midinote, \dur],
			Pseq([
				[57, 2],[56, 2],[55,2],[54,2],[53,4],[47, 0.5],
				[45,0.5],[45,0.5],
				[52,0.5],[60,0.5],[59,0.5],[57,0.5],[55,0.5]
				],1)

	);

	cymbpat = Pbind(\instrument, "garbageCanLid",
	[\freq, \dur],
	Pseq([
		[3810, 1], [1800, 1], [810, 0.5], [4800, 0.5],
		[3000, 1], [1700, 0.5], [810, 1], [4200, 0.5],
		[2000, 0.5], [1780, 0.5], [810, 0.5], [14000, 0.5],
		[25, 0.25], [1780, 0.25], [910, 0.25], [3000, 0.25],
		[25, 0.25], [1780, 0.25], [910, 0.25], [3000, 0.25],
		[3000, 1], [1700, 0.5], [810, 1], [4200, 0.5]
		],1)
		);

	a = Ppar([ melodypat, basspat, cymbpat ]); 	b = Ppar([cymbpat, basspat]);
	Pseq([a, b, a]).play(TempoClock(2)) //binary structure
 )



 /////// default instrument example with three patterns

  (
	var tune, accomp, accomp1, accomp2;

	tune = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[60, 0.5],[62, 0.25],[63, 0.25],[65, 0.5],
				[67,0.5],[68,0.25],[59,0.5],[68,0.25],[67, 0.5],[65, 0.5],[63, 0.5],[62, 0.5],
			],1)  //Defines the melody here
	);

	accomp = Pbind(
			\midinote, Pseq([51, 55, 51, 53, 50, 47]-12, 1),  //defines the bass here
			\dur, 1
	);

	accomp1 = Pbind(
			[\midinote, \dur],
			Pseq([
			[84, 0.25], [86, 0.25], [87, 0.5], [89, 0.25], [91, 0.25],
			 [92, 0.25], [83, 0.25], [81, 0.25], [85, 0.25], [86, 0.5], [98, 0.25], [91, 0.25],
			 [92, 0.25], [83, 0.25]
			 ], 1), \amp, 0.05  //defines the bass here
	);

	accomp2 = Pbind(
			\midinote, Pseq([51, 55, 51, 53, 50, 47]-24, 1),  //defines the bass here
			\dur, 2
	);






//put them in a paired pattern here, assign them to variables and
//construct your form

	a = Ppar([ tune, accomp, accomp1]);
	b = Ppar([accomp]);
	c = Ppar([accomp, accomp1]);
	d = Ppar([tune]);
	e = Ppar([accomp2]);
	f = Ppar([ tune, accomp, accomp1, accomp2]);

	Pseq([e, a, b, c, b, a, d, a, f]).play(TempoClock(2)) //a more complex formal structure
)

///////////reverse engineer this one



/*

Just for fun, here is a patch from the examples to play around with. See if you can
reverse engineer this patch. We will be covering SynthDef and patterns later but
feel free to explore and modify.

*/

// 08091500Acid309 by_otophilia

// other patterns to insert in the ~dseqs below

~dseq = [[1,0,0,0, 0,0,0,0, 1,0,0,1, 0,0,1,0], [0,0,0,0, 0,0,0,2, 0,2,1,0, 4,3,3,3], [0,0,0,0, 4,0,0,0, 0,0,0,0, 4,0,0,0], [1,2,4,0, 1,0,4,0, 1,2,4,2, 1,0,4,2], [1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0]].flop;

~dseq = [[0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0], [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0], [0,0,0,0, 4,0,0,0, 0,0,0,0, 4,0,0,0], [1,2,4,0, 1,0,4,0, 1,2,4,2, 1,0,4,2], [1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0]].flop;

~dseq = [[1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0], [0,0,0,0, 0,0,0,2, 0,0,0,0, 0,0,0,0], [0,0,0,0, 4,0,0,0, 0,0,0,0, 4,0,0,0], [1,2,4,0, 1,0,4,0, 1,2,4,2, 1,0,4,2], [1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0]].flop;

~dseq = [[1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0], [0,0,0,0, 4,0,0,2, 0,0,0,0, 4,0,0,0], [0,0,0,0, 0,0,0,0, 0,0,0,0, 4,0,0,0], [1,2,4,0, 1,0,4,0, 1,2,4,2, 1,0,4,2], [1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0]].flop;


(
Server.default = Server.internal; s = Server.default;
Routine.run {var c; c = Condition.new; s.freeAll; TempoClock.all.do{|x|x.clear}; s.bootSync(c);

( // **** SynthDefs ****

	SynthDef("kick", {
		arg outBus=0;
		var env0, env1, env1m, out;

		env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.26], [-4, -2, -4]), doneAction:2);
		env1 = EnvGen.ar(Env.new([110, 59, 29], [0.005, 0.29], [-4, -5]));
		env1m = env1.midicps;

		out = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
		out = out + WhiteNoise.ar(1);
		out = LPF.ar(out, env1m*1.5, env0);
		out = out + SinOsc.ar(env1m, 0.5, env0);

		out = out * 1.2;
		out = out.clip2(1);

		Out.ar(outBus, out.dup);
	}).send(s);

	SynthDef("snare", {
		arg outBus=0, amp=0.8;
		var env0, env1, env2, env1m, oscs, noise, out;

		env0 = EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.03, 0.10], [-4, -2, -4]));
		env1 = EnvGen.ar(Env.new([110, 60, 49], [0.005, 0.1], [-4, -5]));
		env1m = env1.midicps;
		env2 = EnvGen.ar(Env.new([1, 0.4, 0], [0.05, 0.13], [-2, -2]), doneAction:2);

		oscs = LFPulse.ar(env1m, 0, 0.5, 1, -0.5) + LFPulse.ar(env1m * 1.6, 0, 0.5, 0.5, -0.25);
		oscs = LPF.ar(oscs, env1m*1.2, env0);
		oscs = oscs + SinOsc.ar(env1m, 0.8, env0);

		noise = WhiteNoise.ar(0.2);
		noise = HPF.ar(noise, 200, 2);
		noise = BPF.ar(noise, 6900, 0.6, 3) + noise;
		noise = noise * env2;

		out = oscs + noise;
		out = out.clip2(1) * amp;

		Out.ar(outBus, out.dup);
	}).send(s);

	SynthDef("clap", {
		arg outBus=0, amp = 0.5;
		var env1, env2, out, noise1, noise2;

		env1 = EnvGen.ar(Env.new([0, 1, 0, 1, 0, 1, 0, 1, 0], [0.001, 0.013, 0, 0.01, 0, 0.01, 0, 0.03], [0, -3, 0, -3, 0, -3, 0, -4]));
		env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.3], [0, -4]), doneAction:2);

		noise1 = WhiteNoise.ar(env1);
		noise1 = HPF.ar(noise1, 600);
		noise1 = BPF.ar(noise1, 2000, 3);

		noise2 = WhiteNoise.ar(env2);
		noise2 = HPF.ar(noise2, 1000);
		noise2 = BPF.ar(noise2, 1200, 0.7, 0.7);

		out = noise1 + noise2;
		out = out * 2;
		out = out.softclip * amp;

		Out.ar(outBus, out.dup);
	}).send(s);

	SynthDef("hat", {
		arg outBus=0, amp=0.3;
		var env1, env2, out, oscs1, noise, n, n2;

		n = 5;
		thisThread.randSeed = 4;

		env1 = EnvGen.ar(Env.new([0, 1.0, 0], [0.001, 0.2], [0, -12]));
		env2 = EnvGen.ar(Env.new([0, 1.0, 0.05, 0], [0.002, 0.05, 0.03], [0, -4, -4]), doneAction:2);

		oscs1 = Mix.fill(n, {|i|
			SinOsc.ar(
				( i.linlin(0, n-1, 42, 74) + rand2(4.0) ).midicps,
				SinOsc.ar( (i.linlin(0, n-1, 78, 80) + rand2(4.0) ).midicps, 0.0, 12),
				1/n
			)
		});

		oscs1 = BHiPass.ar(oscs1, 1000, 2, env1);
		n2 = 8;
		noise = WhiteNoise.ar;
		noise = Mix.fill(n2, {|i|
			var freq;
			freq = (i.linlin(0, n-1, 40, 50) + rand2(4.0) ).midicps.reciprocal;
			CombN.ar(noise, 0.04, freq, 0.1)
		}) * (1/n) + noise;
		noise = BPF.ar(noise, 6000, 0.9, 0.5, noise);
		noise = BLowShelf.ar(noise, 3000, 0.5, -6);
		noise = BHiPass.ar(noise, 1000, 1.5, env2);

		out = noise + oscs1;
		out = out.softclip;
		out = out * amp;

		Out.ar(outBus, out.dup);
	}).send(s);

	SynthDef("acid", {
		arg outBus=0, gate=1, pitch=50, amp=0.1;
		var env1, env2, out;
		pitch = Lag.kr(pitch, 0.12 * (1-Trig.kr(gate, 0.001)) * gate);
		env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2.0, 0.04], [0, -4, -4], 2), gate, amp);
		env2 = EnvGen.ar(Env.adsr(0.001, 0.8, 0, 0.8, 70, -4), gate);
		out = LFPulse.ar(pitch.midicps, 0.0, 0.51, 2, -1);

		out = RLPF.ar(out, (pitch + env2).midicps, 0.3);
		out = out * env1;

		Out.ar(outBus, out.dup);
	}).send(s);

	SynthDef("fx", {
		arg outBus=0, gate=0;
		var out;

		out = In.ar(outBus, 2);
		out = FreeVerb2.ar( BPF.ar(out[0], 3500, 1.5), BPF.ar(out[1], 3500, 1.5), 1.0, 0.95, 0.15) * EnvGen.kr(Env.new([0.02, 0.3, 0.02], [0.4, 0.01], [3, -4], 1), 1-Trig.kr(gate, 0.01)) + out;
		out = HPF.ar(out * 1.2, 40);
		out = Limiter.ar(out, 1.0, 0.02);

		ReplaceOut.ar(outBus, out);
	}).send(s);
);

s.sync(c);

( // **** Sequence **** Replace the ~dseq below with ones from the top of the page

	~dseq = [
		[1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0],
		[0,0,0,0, 4,0,0,2, 0,0,0,0, 4,0,0,0],
		[0,0,0,0, 0,0,0,0, 0,0,0,0, 4,0,0,0],
		[1,2,4,0, 1,0,4,0, 1,2,4,2, 1,0,4,2],
		[1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0]
		].flop;


	~bseq = [
		[1,1,1,1, 1,1,1,1, 0,1,0,1, 1,1,1,0],
		[1,1,0,2, 1,1,0,0, 2,0,2,0, 1,2,0,4],
		[-24,-12,0,-12, 0,-12,10,12, 0,7,-7,0, -11,1,13,15] + 38
		].flop;

	~pnt = 0;
	~shf = 0.16;
	~bpm = 130;

	~clock = TempoClock(~bpm/60);

	~clock.sched(0.0, {
		var delta, bass;
		delta = if(~pnt%2 == 0){1/4 * (1+~shf)}{1/4 * (1-~shf)};

		s.bind{
			if(~pnt == 0){
				~group = Group.new;
				~acid = Synth.head(~group, "acid", [\gate, 0]);
				~fx = Synth.after(~group, "fx");
			};

			~dseq.wrapAt(~pnt).do{|x, i|
				switch(i,
					0, { if( x>0 ){ Synth.head(~group, "kick") } },
					1, { if( x>0 ){ Synth.head(~group, "snare", [\amp, (x/4).squared*0.7]) } },
					2, { if( x>0 ){ Synth.head(~group, "clap", [\amp, (x/4).squared*0.5]) } },
					3, { if( x>0 ){ Synth.head(~group, "hat", [\amp, (x/4).squared*0.32]) } },
					4, { ~fx.set(\gate, (x>0).binaryValue) }
				);
			};

			bass = ~bseq.wrapAt(~pnt);
			~acid.set(\pitch, bass[2]);
			if(bass[0]==1){ ~acid.set(\gate, 1) };
		};
		if(bass[1]>0){ ~clock.sched(delta * bass[1]/4 * 0.99, { s.bind{ ~acid.set(\gate, 0) } }) };

		~pnt = ~pnt+1;
		delta;
	});
);

}

)
