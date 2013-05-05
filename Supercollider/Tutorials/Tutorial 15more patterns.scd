(

	SynthDef( "Help-SPE1", { arg i_out=0, freq;
		var out;
		out = RLPF.ar(
			LFSaw.ar( freq, mul: EnvGen.kr( Env.perc, levelScale: 0.3, doneAction: 2 )),
			LFNoise1.kr(1, 36, 110).midicps,
			0.1
		);
		out = [out, DelayN.ar(out, 0.04, 0.04) ];
		4.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
		Out.ar( i_out, out );
	}).send(s);
)
(
// streams as a sequence of pitches
	var stream, dur;
	dur = 1/8;
	stream = Routine.new({
		loop({
			if (0.5.coin, {
				// run of fifths:
				24.yield;
				31.yield;
				36.yield;
				43.yield;
				48.yield;
				55.yield;
				62.yield;
				69.yield;
			});
			rrand(2,5).do({
				// varying arpeggio
				60.yield;
				#[63,65].choose.yield;
				67.yield;
				#[70,72,74].choose.yield;
			});
			// random high melody
			rrand(3,9).do({  #[74,75,77,79,81,84,86,87].choose.yield });
		});
	});
	Routine({
		loop({
			Synth( "Help-SPE1", [ \freq, stream.next.midicps ] );
			dur.wait; // synonym for yield, used by .play to schedule next occurence
		})
	}).play
)


////////////////////////////////////

/
// Clapping Music by Steve Reich (1972)
//

(
// Building Blocks
Ppar([
Pbind(\tempo, 2, \dur, 0.3, \midinote, Pseq([62, 62, 62, 0, 62, 62,
0, 62, 0, 62, 62, 0], inf)),
Pbind(\tempo, 2, \dur, 0.3, \midinote, Pseq([62, 62, 62, 0, 62, 62,
0, 62, 0, 62, 62, 0], inf)),
]).play
)

(
// Clapping Music (Take 1)
var repeats;
repeats = 4;
// p means play an 8th note, r means 8th rest
p = 62;
r = 0;
Ppar([
Pbind(\pan, -1, \tempo, 2, \dur, 0.3, \sustain, 0.05, \midinote,
Pseq([p, p, p, r, p, p, r, p, r, p, p, r], 12 * repeats)),
Pbind(\pan,  1, \tempo, 2, \dur, 0.3, \sustain, 0.05, \midinote,
Pslide([p, p, p, r, p, p, r, p, r, p, p, r], 12, 12 * repeats, 1, 0)),
]).play
)


(
// Clapping Music (Take 2 -- Incorporate dynamics and that 12/8 feel)
var repeats, environ;
repeats = 4;
// p means play an 8th note, r means 8th rest
p = 62;
r = 0;
// a means accent, n means normal
a = 0.7;
n = 0.3;
environ = Pbind(\tempo, 2, \dur, 0.3, \sustain, 0.05, \amp, Pseq([a,
n, n, a, n, n, a, n, n], inf));
Ppar([
Pbindf(environ, \pan, -1, \midinote,   Pseq([p, p, p, r, p, p, r, p,
r, p, p, r], 12 * repeats)),
Pbindf(environ, \pan,  1, \midinote, Pslide([p, p, p, r, p, p, r, p,
r, p, p, r], 12, 12 * repeats, 1, 0)),
]).play
)

(
// Clapping Music (Take 3 -- A custom instrument)
var repeats, environ;

SynthDef("clap", { arg i_out=0, freq = 800, amp = 0.2, pan=0, gate = 1;
var out;
out = Decay2.ar(Impulse.ar(1), 0.01, 0.2, FSinOsc.ar(freq)) *
Linen.kr(gate, 0.01, 0.7, 0.3, 2);
OffsetOut.ar(i_out, Pan2.ar(out, pan, amp));
}).add;

repeats = 4;
// p means play an 8th note, r means 8th rest
p = 80;
r = 0;
// a means accent, n means normal
a = 0.7;
n = 0.3;
environ = Pbind(\instrument, 'clap', \tempo, 2, \dur, 0.3, \sustain,
0.05, \amp, Pseq([a, n, n, a, n, n, a, n, n], inf));
Ppar([
Pbindf(environ, \pan, -1, \midinote,   Pseq([p, p, p, r, p, p, r, p,
r, p, p, r], 12 * repeats)),
Pbindf(environ, \pan,  1, \midinote, Pslide([p, p, p, r, p, p, r, p,
r, p, p, r], 12, 12 * repeats, 1, 0)),
]).play
)

--
C. Ramakrishnan           cramakrishnan@acm.org
Illposed Software             http://www.illposed.com

/////////////////////////////////////////

(
	var tune, accomp, accomp1;

	tune = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[60, 0.5],[62, 0.25],[63, 0.25],[65, 0.5],
				[67,0.5],[68,0.25],[59,0.5],[68,0.25],[67, 0.5],[65, 0.5],[63, 0.5],[62, 0.5],
			],inf)  //Defines the melody here
	);

	accomp = Pbind(
			\midinote, Pseq([51, 55, 51, 53, 50, 47]-12, inf),  //defines the bass here
			\dur, 1
	);

	accomp1 = Pbind(
			[\midinote, \dur],
			Pseq([
			[84, 0.25], [86, 0.25], [87, 0.5], [89, 0.25], [91, 0.25],
			 [92, 0.25], [83, 0.25], [81, 0.25], [85, 0.25], [86, 0.5], [98, 0.25], [91, 0.25],
			 [92, 0.25], [83, 0.25]
			 ], inf), \amp, 0.05  //defines the bass here

	);


	Ppar([ tune, accomp, accomp1 ]).play(TempoClock(2));
				//put them in a paired pattern here
)

/////////////////

(
	var tune, accomp, accomp1, chord1, chord2, chord3, chord4;

	tune = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[60, 0.5],[62, 0.25],[63, 0.25],[65, 0.5],
				[67,0.5],[68,0.25],[59,0.5],[68,0.25],[67, 0.5],[65, 0.5],[63, 0.5],[62, 0.5],
			],inf)  //Defines the melody here
	);

	accomp = Pbind(
			\midinote, Pseq([51, 55, 51, 53, 50, 47]-12, inf),  //defines the bass here
			\dur, 1
	);

	accomp1 = Pbind(
			[\midinote, \dur],
			Pseq([
			[84, 0.25], [86, 0.25], [87, 0.5], [89, 0.25], [91, 0.25],
			 [92, 0.25], [83, 0.25], [81, 0.25], [85, 0.25], [86, 0.5], [98, 0.25], [91, 0.25],
			 [92, 0.25], [83, 0.25]
			 ], inf), \amp, 0.05  //defines the bass here

	);

chord1 = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[0, 5],[40, 4],[43, 3],[45, 2],
							],inf)  //Defines the chord here
);

chord2 = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[0, 5],[50, 4],[53, 3],[55, 2],
							],inf)  //Defines the chord here
);

chord3 = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[0, 5],[60, 4],[63, 3],[65, 2],
							],inf)  //Defines the chord here
);

chord4 = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[0, 5],[70, 4],[73, 3],[75, 2],
							],inf)  //Defines the chord here
);





	Ppar([ tune, accomp, accomp1, chord1, chord2, chord3, chord4 ]).play(TempoClock(2));
				//put them in a paired pattern here
)

//////////

(
	var tune, accomp, accomp1, chord1, chord2, chord3, chord4;

	tune = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[60, 0.5],[62, 0.25],[63, 0.25],[65, 0.5],
				[67,0.5],[68,0.25],[59,0.5],[68,0.25],[67, 0.5],[65, 0.5],[63, 0.5],[62, 0.5],
			],inf)  //Defines the melody here
	);

	accomp = Pbind(
			\midinote, Pseq([51, 55, 51, 53, 50, 47]-12, inf),  //defines the bass here
			\dur, 1
	);

	accomp1 = Pbind(
			[\midinote, \dur],
			Pseq([
			[84, 0.25], [86, 0.25], [87, 0.5], [89, 0.25], [91, 0.25],
			 [92, 0.25], [83, 0.25], [81, 0.25], [85, 0.25], [86, 0.5], [98, 0.25], [91, 0.25],
			 [92, 0.25], [83, 0.25]
			 ], inf), \amp, 0.05  //defines the bass here

	);

chord1 = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[0, 5],[40, 4],[43, 3],[45, 2],
							],inf)  //Defines the chord here
);

chord2 = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[0, 5],[50, 4],[53, 3],[55, 2],
							],inf)  //Defines the chord here
);

chord3 = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([
				[0, 5],[60, 4],[63, 3],[65, 2],
							],inf)  //Defines the chord here
);

chord4 = Pbind(
			[\midinote, \dur], //ties the note to the duration
			Pseq([Pseq([
				[0, 5],[70, 4],[73, 3],[75, 2],],2),
		            [80, 5], [82, 4],], inf)  //Defines the drifting chord here
);





	Ppar([ tune, accomp, accomp1, chord1, chord2, chord3, chord4 ]).play(TempoClock(2));
				//put them in a paired pattern here
)


