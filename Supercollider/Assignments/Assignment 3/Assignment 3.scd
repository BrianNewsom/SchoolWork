/*1. Find Synth Defs*/
s.boot;
var sine;
(//Rising pitches in sin and saw
{
var sine, saw;

var mulEnv1 = Env.new([0, 0.5, 0.5, 0], //env for sine
			[5, 8, 2],
			[1, 0, 0]); //Leave blank for linear

var freqEnv1 = Env.new([40, 2000, 880, 220],
	times:[5,8,5],
	curve:'exp');

var freqEnv2 = Env.new([0, 0, 2000, 220],
	times:[5,2,7,4]);

	var mulEnv2 = Env.new([0.5,0],
	times:[15,5]);

sine = {
	SinOsc.ar(EnvGen.kr(freqEnv1), 0, EnvGen.kr(mulEnv1))};


saw = {
	Saw.ar(EnvGen.kr(freqEnv2),EnvGen.kr(mulEnv2))};



LeakDC.ar(saw+sine);
}.play;
)

(

{//Parallel fifths with harmonics, just tempered
var freq, ratioNum, ratioDenum, mul; //declare two variables
ratioNum = 3; //assign numerator
ratioDenum = 2; //assign denominator
freq = Env.new([1000,400,60, 20],
		times:[5,10,5,10]);
mul = Env.new([0.0,0.3,0.2,0],
		times:[3,5,5,10, 5]);

Blip.ar(
		[EnvGen.kr(freq), EnvGen.kr(freq)*(ratioNum/ratioDenum)], 5,
		EnvGen.kr(mul))
}.scope(2);
)
//Bassy Random pitches
(
var mulEnv4 = Env.new([0,0.3,0.2,0],
	times:[5,4,25]);
var out;
{
out = Mix.new(
	Array.fill(5,
	{arg counter;
	var partial;
	partial = counter*2;
				SinOsc.ar(Rand(50,100)*EnvGen.kr(Env.adsr(0,0,1.0,2.0),timeScale: 1/partial));//levelBias: 0.5)
		})*EnvGen.kr(mulEnv4);
)
}.play;

)
//Sick beats yo
var freqEnv5 = Env.new([[0.99,1,2,0.98],[0.77,0.8,1.6,0.79],[100,20,50,57]],times:[10,5,6]);


SynthDef(\guitar2, { arg freq, amp, pan = 0;
var out, pluck, period, string;
freq = freq * EnvGen.kr(freqEnv5);
pluck = PinkNoise.ar(Decay.kr(Line.kr(1, 0, 0.05), 0.05));
period = freq.reciprocal;
string = CombL.ar(pluck, period, period, 4);
out = LeakDC.ar(LPF.ar(string, 12000));
out = Splay.ar(out, XLine.ar(0.1,1,0.3));
out = out * XLine.ar(1,1/1000,4, doneAction:2);
Out.ar(0, Pan2.ar(out, pan, amp) * 0.4);
} ).send(s);

SynthDef(\guitar, { arg freq, amp, pan = 0;
var out, pluck, period, string;
freq = freq * EnvGen.kr(freqEnv5);
out = SinOsc.ar(freq);
out = Splay.ar(out, XLine.ar(0.1,1,0.3));
out = out * XLine.ar(1,1/1000,2, doneAction:2);
Out.ar(0, Pan2.ar(out, pan, amp) * 0.4);
} ).send(s);

SynthDef(\ch, { | decay = 3, amp = 1, freq = 440 |
f = WhiteNoise.ar;
f = LPF.ar(f, 12000);
//f = f+ DelayC.ar(f, 0.1,LFNoise2.ar(1/2).range(0.001,0.01));
f = HPF.ar(f, 4000, 0.05);
f = f * EnvGen.kr(Env.perc(0.01,decay*0.8), doneAction:2);
Out.ar(0, 15 * f.dup * amp);
}).store;

SynthDef(\kick, { | decay = 0.03, amp = 1, freq = 40 |
var f = SinOsc.ar(freq*XLine.ar(1,1/4,0.1));
f = f * EnvGen.kr(Env.perc(0.0001,decay), doneAction:2);
Out.ar(0,f.dup * amp * 1);
}).store;

TempoClock.default.tempo = 120/60;


(
a = Ppar([
	Pbind(
		\instrument, \guitar,
		\strum, 2/Pstep([32,16,3,12],2,inf),
		\degree, Pseq([
				[0,2,4,6],
				[-1,2,4,6],
				[0,2,4,6],
				[0,2,4,6]-2,
			],inf),
		\octave, 5,
		\dur, 1,
		\decay, Pseq([1],inf),
	),
			Ppar([
		Pbind(\instrument, \kick, \dur, 1/4, \decay, Pstep([2,0.3],1/4,inf) * 0.7, \octave, 4, \amp, Pstep([1,0,0,1, 0,0,1,0, 0,0.2,1,0, 0,0,0,0],1/4,inf)),
		Pbind(\instrument, \ch,
			\decay, 0.3,
		\dur, 1/Pstep([8,4,4,4,1,1,6,1],1,inf),
		\decay, Pn(Pseg([0.3,0.1],1)) / 2,
		\amp, Pstep([0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0],1/4,inf) + (0.1*Pn(Pseg([0,0.4],1)))
	)
		])
])
)
a.play;

//Ocean
{

	x = OnePole.ar(WhiteNoise.ar(EnvGen.kr(mulEnv6))+Dust.ar(0, 0.5), 0.7);
x = x + Splay.ar(FreqShift.ar(x, 1/(4..7)));
}.play

//beats yo
var mulEnv7 = Env.new([1,5,3,0],times:[4,10,7,4,4],curve:'exp');
play{a=Impulse;tanh(a.kr(8).lag*Crackle.ar(LFSaw.kr(3).abs.lag*1.8)+GVerb.ar([a.kr(2)+a.kr(4,0.5)].lag*Blip.ar(4.9,7,0.4)!2,1,1)*EnvGen.kr(mulEnv7))}

/*********************************************************
* The legendary Super Mario Theme for SuperCollider      *
* created by David Hofmann, HfM Karlsruhe, February 2011 *
*                                                        *
* Contains all three voices and percussion sounds        *
**********************************************************/
(
a = {
(
// global pitch Offset, can be used to transpose the whole song
~pitchOffset = 60;

// global duration divisor, can be used to make the song faster or slower
~durParam = 4;

// *************************** SynthDefs ***************************

// SynthDef for the first and second voice
SynthDef(\mario, { |out, amp=0.3, freq=440|
	var snd;
	snd = LFPulse.ar(freq)!2;
	snd = snd * EnvGen.ar(Env.linen(0.001, 0.1, 0.03), doneAction:2);
	OffsetOut.ar(out, snd*amp);
}).add;

// SynthDef for the bass
SynthDef(\bass, { |out, amp=0.5, freq=440|
	var snd;
	snd = LFTri.ar(freq)!2;
	snd = snd * EnvGen.ar(Env.linen(0.001, 0.1, 0.03), doneAction:2);
	OffsetOut.ar(out, snd*amp);
}).add;


// SynthDef for percussion sounds
SynthDef(\beat, { |out, amp=0.3, sustain=0.01|
	var snd;
	snd = WhiteNoise.ar()!2;
	snd = HPF.ar(snd, 2000);
	snd = snd * EnvGen.ar(Env.linen(0.005, sustain, 0.01), doneAction:2);
	OffsetOut.ar(out, snd*amp);
}).add;

//Synth(\mario);
//Synth(\bass);
//Synth(\beat, [\sustain, 0.05]);

(
{
	/* Here comes the note and rhythm data.
	 * The overall sequence of the song is:
	 * Intro
	 * Part 1 (2x)
	 * Part 2 (2x)
	 * Part 3
	 * Intro
	 * Part 1 (2x)
	 * Part 4 (2x)
	 * Part 3
	 * Intro */

	// Pseqs of note lengths. These rhythms are used by voice 1 and 2 commonly, they are always parallel
	// Intro
	var times_intro =  Pseq([1, 2, 2, 1, 2, 4, 4]);
	// Part 1
	var triplet = Pn(4/3, 3);
	var times_part1 = Pseq([ Pn(3,3), 2,  2, 1, 2, triplet,  2,  1,  2,  2,  1,  1,  3]);
	// Part 2
	var seq1 = Pseq([Pn(1,3), 2, 2]);
	var seq2 = Pseq([1, 1, 2, 1, 1, 3]);
	var times_part2  =  Pseq([2, seq1, seq2, seq1, 2, 1, 6, seq1, seq2,  3, 3, 8]);
	// Part 3
	var seq3 = Pseq([1, 2, 2, 1, 2, 1, 2, 1, 4]);
	var times_part3  = Pseq([ seq3, 1, 2, 2, 1, 1, 9, seq3]);
	// Part 4
	var seq4 = Pseq([1, 2, 3, 2, 1, 2, 1, 4]);
	var times_part4  = Pseq([seq4, Pn(triplet, 2),  1, 2, 1, 4, seq4, Pn(triplet, 2), 8]);

	// *************************** Notes for Voice 1 ***************************
	// Intro
	var notes_intro_1 = Pseq([Pn(16,3), 12, 16, 19, 7]);
	// Part 1
	var notes_part1_1 = Pseq([12, 7, 4, 9, 11, 10, 9, 7, 16, 19, 21, 17, 19, 16, 12, 14, 11 ]);
	// Part 2
	var nseq1 = Pseq([19, 18, 17, 15, 16]);
	var nseq2 = Pseq([7, 9, 12, 9, 12, 14]);
	var notes_part2_1 = Pseq([\rest, nseq1, nseq2, nseq1, Pn(24,3), nseq1, nseq2, 15, 14, 12]);
	// Part 3
	var nseq3 = Pseq([Pn(12,4), 14, 16]);
	var notes_part3_1 = Pseq([nseq3, 12, 9, 7, Pn(nseq3, 2), 12, 9, 7]);
	// Part 4
	var nseq4 = Pseq([16, 12, 7, 8, 9, 17, 17, 9, 11]);
	var notes_part4_1 = Pseq([nseq4, Pn(21,3), 19, 17, 16, 12, 9, 7, nseq4, Pn(17,3), 16, 14, 12]);

	// *************************** Notes for Voice 2 ***************************
	// Intro
	var notes_intro_2 = Pseq([Pn(6,5), 7, 7]);
	// Part 1
	var notes_part1_2 = Pseq([4, 0, -5, 0, 2, 1, 0, 0, 7, 11, 12, 9, 11, 9, 2, 5, 2 ]);
	// Part 2
	var nseq5 = Pseq([16, 15, 14, 11, 12]);
	var nseq6 = Pseq([4, 5, 7, 0, 4, 5]);
	var notes_part2_2 = Pseq([\rest, nseq5, nseq6, nseq5, Pn(19,3), nseq5, nseq6, 8, 5, 4]);
	// Part 3
	var nseq7 = Pseq([Pn(8,4), 10, 7]);
	var notes_part3_2 = Pseq([nseq7, 4, 4, 0, Pn(nseq7, 2), 4, 4, 0]);
	// Part 4
	var nseq8 = Pseq([12, 9, 4, 4, 5, 12, 12, 5, 7]);
	var notes_part4_2 = Pseq([nseq8, Pn(17,3), 16, 14, 12, 9, 5, 4, nseq8, Pn(14,3), 12, 11, 7]);

	// *************************** Rhythm and notes for the bass ***************************
	// Intro
	var notes_intro_bass = Pseq([2, 2, 2, 2, 2, 11, 7-12]);
	// Part 1
	var notes_part1_bass = Pseq([7, 4, 0, 5, 7, 6, 5, 4, 12, 16, 17, 14, 16, 12, 9, 11, 7]-12);
	// Part 2
	var nseq9 = Pseq([0, 7, 12, 5, Pn(12,3), 5, 0]);
	var notes_part2_bass = Pseq([nseq9, 4, 7, 12, Pn(29,3), 7, nseq9, 8, 10, 12, 7, 7, 0]-12);
	var seq5 = Pseq([3, 3, 2, 3, Pn(1,3), 2]);
	var seq6 = Pseq([3, 3, 1, 2, 2]);
	var times_part2_bass  = Pseq([seq5, seq6, 1, 2, 2, seq5, 2, 3, seq6]);
	// Part 3
	var nseq10 = Pseq([8, 15, 20, 19, 12]);
	var notes_part3_bass = Pseq([nseq10, 7, nseq10, 12, 7, nseq10, 7]-24);
	var seq7 = Pseq([3, 3, 2]);
	var times_part3_bass  = Pseq([Pn(seq7, 3), 3, 1, 2, 2, Pn(seq7, 2)]);
	// Part 4
	var nseq11 = Pseq([0, 3, 4, 12, 5, 5, 12, 12, 5]);
	var notes_part4_bass = Pseq([nseq11, 2, 5, 7, 11, 7, 7, 12, 12, 7, nseq11, Pn(7,3), 9, 11, 12, 7, 7, 0]-12);
	var seq8 = Pseq([3, 1, Pn(2,4), 1, 1, 2]);
	var times_part4_bass  = Pseq([Pn(seq8,3), 3, 1, triplet, 1, 2, 1, 4]);

	// *************************** Rhythm (times) and sustain lengths (notes) of the percussion track ***************************
	// Intro
	var notes_intro_drums = Pseq([5, 1, 5, 1, 5, 5, 5, 1, 1, 1]);
	var times_intro_drums = Pseq([2, 1, 2, 1, 2, 3, 2, 1, 1, 1]);

	// Part 1
	var notes_part1_drums = Pseq([\rest, 1, 1, 5, 1, 1]);
	var times_part1_drums = Pseq([2,8/6,4/6,2,8/6,4/6]);

	// Part 2 has the same drums as part 1
	// Part 3 notes are the same as the intro notes
	var times_part3_drums = Pseq([2, 1, 2, 1, 2, 3, 2, 1, 1, 1]);

	// Part 4
	var notes_part4_drums = Pseq([1, 1, 5, 1]);
	var times_part4_drums = Pseq([3, 1, 2, 2]);

	// whole percussion track
	var drums_notes = Pseq([notes_intro_drums, Pn(notes_part1_drums, 8), Pn(notes_part1_drums, 16), Pn(notes_intro_drums, 4), Pn(notes_part1_drums, 8), Pn(notes_part4_drums, 16), Pn(notes_intro_drums, 4)]/100);

	// *************************** Pdefs ***************************
	// Pdef for Voice 1
	Pdef(\voice1, Pbind(
		\instrument, \mario,
		\dur, Pseq([times_intro, Pn(times_part1, 2), Pn(times_part2, 2), times_part3, times_intro, Pn(times_part1, 2), Pn(times_part4, 2), times_part3, times_intro]/~durParam),
		\midinote, Pseq([notes_intro_1, Pn(notes_part1_1, 2), Pn(notes_part2_1, 2), notes_part3_1, notes_intro_1, Pn(notes_part1_1, 2), Pn(notes_part4_1, 2), notes_part3_1, notes_intro_1]+~pitchOffset)
	)).play;

	// Pdef for Voice 2
	Pdef(\voice2, Pbind(
		\instrument, \mario,
		\dur, Pseq([times_intro, Pn(times_part1, 2), Pn(times_part2, 2), times_part3, times_intro, Pn(times_part1, 2), Pn(times_part4, 2), times_part3, times_intro]/~durParam),
		\midinote, Pseq([notes_intro_2, Pn(notes_part1_2, 2), Pn(notes_part2_2, 2), notes_part3_2, notes_intro_2, Pn(notes_part1_2, 2),Pn(notes_part4_2, 2), notes_part3_2, notes_intro_2]+~pitchOffset)
	)).play;

	// Pdef for the Bass
	Pdef(\voice3, Pbind(
		\instrument, \bass,
		\dur, Pseq([times_intro, Pn(times_part1, 2), Pn(times_part2_bass, 2), times_part3_bass, times_intro, Pn(times_part1, 2), Pn(times_part4_bass, 2), times_part3_bass, times_intro]/~durParam),
		\midinote, Pseq([notes_intro_bass, Pn(notes_part1_bass, 2), Pn(notes_part2_bass, 2), notes_part3_bass, notes_intro_bass, Pn(notes_part1_bass, 2),Pn(notes_part4_bass, 2), notes_part3_bass, notes_intro_bass]+~pitchOffset)
	)).play;

	// Pdef for the percussion track
	// it uses the notes both for \degree and \sustain. The \degree mapping is only needed for rests
	Pdef(\percussion, Pbind(
		\instrument, \beat,
		\dur, Pseq([times_intro_drums, Pn(times_part1_drums, 8), Pn(times_part1_drums, 16), Pn(times_part3_drums, 3), times_intro_drums, Pn(times_part1_drums, 8), Pn(times_part4_drums, 16), Pn(times_part3_drums, 3), times_intro_drums]/~durParam),
		\degree, drums_notes,
		\sustain, drums_notes
	)).play;

}.value*0
)
)
}
)
a.play;
var mulEnv8 = Env.new([1,0.0],[10,15]);

{a*0}.play;

//Circus melting in space
play{a=Mix(Array.fill(75,{|i|SinOsc.ar(rrand(1,50)*i+10,0,LFNoise1.kr([1.8,2.3]))}))*0.02;CombL.ar(a,15,SinOsc.ar([0.1,0.11],0,0.5,0.6),10)}
s.boot;

//Winter curves
(
fork { loop {
	Ndef(\winter_curves, {
		var bands = 5.rrand(15) * 2;
		var freqs = Array.exprand(bands.debug('bands'), 20, 18000);
		Pan2.ar(
			SinOsc.ar(
				freqs,
				Array.rand(bands, 0, pi),
				AmpCompA.kr(freqs, freqs.sort.first)
			).perform(0.5.coin.if(\tanh,\value).debug('kind')),
			FSinOsc.kr(
				Array.exprand(bands, 0.01, 15),
				Array.rand(bands, 0, pi),
			),
			bands.reciprocal
			* LFGauss.kr(SinOsc.kr(Array.rand(bands, 0.05, 0.1)).range(1,10), 0.3)
			* FSinOsc.kr(
				Array.exprand(bands, 0.1, 15),
				0.3
			).range(0,1)
		).sum
		* SelectX.kr(
			FSinOsc.kr(Array.exprand(bands, 0.1, 15)).range(0,1),
			[
				EnvGen.kr(
					Env.perc(
						FSinOsc.kr(1/16).range(0.01,0.1),
						FSinOsc.kr(1/8).range(0.25,0.3)
					).blend(
						Env.sine( // 1/4
							FSinOsc.kr(Array.exprand(bands, 0.1, 15)).range(0.05,2)
						).blend(
							Env.sine(1/4),
							FSinOsc.kr(Array.exprand(bands, 0.1, 15)).range(0.05,2).mean
						),
						FSinOsc.kr(Array.exprand(bands, 0.1, 15)).range(0,1)
					).circle,
					1, 0.8,
					FSinOsc.kr(freqs.linlin(20,18000,0.1,20)).range(0, 0.2).mean
				),
				1
			]
		).clump(2).mean
	}).fadeTime_(0.5.rrand(2.5)).play;
	8.rrand(30).debug('len').wait;
} }
)
//Tribal drums
var tempEnv1 = Env.new([1,4,5,4,100],times:[4,5,6,4]);
var mulEnv8 = Env.new([1,0.5,0.7,0],times:[4,5,6,4],curve:'exp');
(
{
	var exc, amp;
	amp = LFPulse.kr(EnvGen.kr(tempEnv1),0,0.1,0.002);//change the freq arg to change tempo
	exc = LPZ1.ar(GrayNoise.ar([amp,amp]));
	Klank.ar(`[FloatArray.fill(4, { rrand(80.0,200.0) }),
			nil,
			FloatArray[1, 1, 1, 1]], exc);
}
)