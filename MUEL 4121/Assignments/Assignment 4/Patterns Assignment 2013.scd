s.makeWindow.boot;

/*
PATTERNS ASSIGNMENT

Compose a piece, with at least two voice polyphony, using Pbind, Pseq, Ppar, etc.
You may use the default instrument, but you are strongly encouraged to create
your own synths.

DUE: Thursday April 4!!!


Your trio got a gig at a sad Holiday Inn:

http://www.nwigs.org/ImageArchive/Valparaiso/Hotels-Motels/ValparaisoIndiana-HolidayInn-Wellmans2-Circa1965-SS.jpg

So go to the musty lounge to play the job
and the keyboard player has been drinking Jack Daniels...
You play and get a few $$ and you're still broke... Why not ditch
these guys and do everything with SuperCollider?!

This sequence uses very basic synths and puts them, in the case of the bass
and keyboard chords, in nested patterns. Also notice that there are two Ppar nested
in a Ptpar.

Ptpar([0.0, Ppar([track1, track2, track3]), 24.0,
		Ppar([bass, guit1, guit2, guit3, guit4])]).play(TempoClock(4));

Here, the Ptpar starts the first Ppar right away and then delays the second
Ppar by 24 beats.

*/

(
//Here's the band

// drum1 are the cymbals and bass drum

SynthDef("drum1",
{
arg dur = 1, freq = 2820;
a = PinkNoise.ar;
	b = BPF.ar(a, freq, 0.2) * EnvGen.kr(Env.perc(0.0, 1, 1, -4),doneAction:2);
	e = FreeVerb.ar(b, 0.5, 0.7, 0, 4);
Out.ar([0, 1], e)
}).load(s);


//drum2 is the high hat

SynthDef("drum2",
{
arg dur = 1, freq = 2820;
	a = PinkNoise.ar;
	b = BPF.ar(a, freq, 0.2) * EnvGen.kr(Env.perc(0.0, 0.11, 1, -4),doneAction:2);
Out.ar([0, 1], b)
}).load(s);


// this is one of those MIDI keyboards that hangs off your shoulder like a guitar

SynthDef("bass",
{arg midinote = 60, amp = 1, dur = 4, pan = 0, legato = 0.8;

	 v = Pan2.ar(
			Pulse.ar(midinote.midicps, SinOsc.ar(4, 0, amp, 0.5), 0.1)
			*
			EnvGen.kr(Env.perc(0.05, dur*legato), doneAction: 2),
			pan);
			v = FreeVerb.ar(v, 0.5, 0.7, 0.5, 1);
	Out.ar([0, 1], v);
	}).load(s);


//Radio Shack Fender Rhodes...

SynthDef("fender2",
{
arg midinote = 60, dur = 1, legato = 0.2;
	x = PMOsc.ar(midinote.midicps, midinote.midicps + 10, 1, 0, 0.4)
	*
	EnvGen.kr(Env.perc(0.0, 3, 1), doneAction: 2);
	x = Pan2.ar(x, 0, 0.3);
	x = FreeVerb.ar(x, 0.7, 0.9, 0.5, 0.5);
Out.ar([0, 1], x)
	}).load(s);

)

//Here's the chart

(
var track1, track2, track3, bass, guit1, guit2, guit3, guit4;

//ride cymbal

track1 = Pbind(\instrument, "drum1",
	[\freq, \dur],
	Pseq([
		[13810, 1], [14000, 1], [12810, 2/3], [14800, 1/3],
		[14810, 1], [14500, 1], [12000, 1], [13800, 1],
		[14810, 1], [14500, 1], [12000, 2/3], [13800, 1/3],
		[14010, 1], [14900, 1], [12000, 2/3], [12800, 1/3],
		[14810, 1], [14500, 1], [12000, 1], [13800, 1]
		],inf)
		);
//
//bass drum

track2 = Pbind(\instrument, "drum1",
	[\freq, \dur],
	Pseq([
		[25, 2], [35, 2]],inf)
		);

//hat cymbal

track3 = Pbind(\instrument, "drum2",
	[\freq, \dur],
	Pseq([
		[0.25, 1], [4000, 1]],inf)
		);

//bass line

bass = Pbind( \instrument, "bass",
			[\midinote, \dur],
			Pseq([
				Pseq([
					[48, 1], [36, 1], [37, 1], [38, 1], [39, 1],
					[40, 1]
					],2),

				[35, 1], [34, 1], [33, 1], [32, 1], [40, 1],
				[37, 1], [31, 1], [32, 1], [34, 1], [35, 1],

					Pseq([
						[48, 1], [36, 1], [37, 1], [38, 1], [39, 1],
						[40, 1]
						],2),

				[37,1], [38, 1], [40, 1], [31, 1], [32, 1],
				[34, 2/3], [35, 1/3],[37,1], [38, 1], [40, 1],
		       [52, 1], [50, 1], [49,1], [47,1], [46, 1],
				[44,1], [43, 1], [42, 1], [30, 1], [32, 1],
				[33, 1], [35, 1], [36, 2/3], [38, 1/3], [39, 1],
				[41, 1]

				],inf)
				);

//chord root

guit1 = Pbind( \instrument, "fender2",
			[\midinote, \dur],
			Pseq([
				Pseq([
					[60, 8], [61, 12], [61, 5], [60, 22]
					], 2),
				[66, 5], [65, 5], [64, 5], [63, 12],
				[67, 3], [66, 3], [65, 3], [64, 5], [63, 5], [62, 18]
				],inf)
				);

//chord extentions

guit2 = Pbind( \instrument, "fender2",
			[\midinote, \dur],
			Pseq([
				Pseq([
					[63, 8], [64, 12], [64, 5], [63, 22]
					], 2),
				[69, 5], [68, 5], [67, 5], [66, 12],
              [70, 3], [69, 3], [68, 3], [67, 5], [66, 5], [65, 18]
				],inf)
				);

//chord extentions

guit3 = Pbind( \instrument, "fender2",
			[\midinote, \dur],
			Pseq([
				Pseq([
					[65, 8], [66, 12], [66, 5], [65, 22]
					], 2),
				[71, 5], [70, 5], [69, 5], [68, 12],
				[72, 3],[71, 3], [70, 3], [69, 5], [68, 5], [67, 18]
				],inf)
				);

//chord extentions

guit4 = Pbind( \instrument, "fender2",
			[\midinote, \dur],
			Pseq([
				Pseq([
					[70, 8], [71, 12], [71, 5], [70, 22]
					], 2),
				[76, 5], [75, 5], [74, 5], [73, 12],
				[77, 3], [76, 3], [75, 3], [74, 5], [73, 5], [72, 18]
				],inf)
				);


Ptpar([0.0, Ppar([track1, track2, track3]), 24.0,
	Ppar([bass, guit1, guit2, guit3, guit4])]).play(TempoClock(4));
)
