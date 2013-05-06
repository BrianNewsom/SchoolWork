s.makeWindow.boot;

/*
Tutorial 10

Karplus/Strong,
Karplus-Strong Pluck Instrument

The Karplus/Strong "pluck" is a physical model that begins with noise.
It models a plucked string, which when set in motion by the chaotic pluck of a finger
or pick, reproduces that event as it swings from one side to the other. Karplus-Strong
achieves this effect by using a delay ugen. A burst of noise is released into an echo
chamber and the repeating and decaying echoes comprise the periodic repetition of
the burst, which if short enough in duration is then perceived as a pitch.

http://en.wikipedia.org/wiki/Karplus-Strong_string_synthesis

Karplus-Strong Pluck Instrument

We begin with a very short burst of noise.

noise burst
*/

(
{
	var burstEnv, att = 0, dec = 0.001; //Variable declarations
	burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1)); //envelope
	PinkNoise.ar(burstEnv); //Noise, amp controlled by burstEnv
}.play
)

/*
Delays

The next step is to send the burst of noise through an echo chamber; CombL, which has these
arguments in, maxdelaytime, delayTime, decayTime, mul, add. The input is going to be the
burst of noise we just created. The delaytime and maxdelaytime are the same for this
example. They represent the amount of time, in seconds, the signal is delayed (the echo). The
decaytime is how long it takes for the echo to die away. Try changing the delayTime and the
decayTime. The gate frequency is set to the reciprocal of the duration delayDecay so a new
impulse triggers another burst of noise when the previous one has died away.


Noise burst with delay
*/

(
{
	var burstEnv, att = 0, dec = 0.001;
	var out, delayTime = 0.5, delayDecay = 10;
	burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
	out = PinkNoise.ar(burstEnv);
	out = out + CombL.ar(
		out,
		delayTime,
		delayTime,
		delayDecay); //Echo chamber
	out
}.play
)

/*
Why use noise as an excitation source? Notice that each pluck sound is a little different. This
is because each new burst of noise is slightly different than the previous. (Not the echoes, but
the initial burst.) The result is subtle, but add natural variations to the sound. If you were to
add a RandSeed with the same trigger as the noise burst, this seed will reset the number generator
and you will get the same burst of noise each timecausing the plucks all sound alike.

Change the delay time to 0.1 (ten times per second, or 10 Hz), 0.01 (100 times per second, or
100 Hz), then 0.001 (1000 Hz), etc. The delay time is the reciprocal to the pitch we hear
(1/100th of a second, 100 Hz). What delay time would we enter for A 440?

Notice that we have a similar problem as discussed in previous chapters regarding duration
and frequency. Since we are creating a pitched event, we think in terms of frequency. But the
delay argument in CombL is a duration. To achieve a certain pitch, say, 200 Hz, we have to
enter the duration of each cycle for that pitch: 1/200th of a second.

SC can do the calculation with the reciprocal message. The line 440.reciprocal will return
the duration of each period of a wave with a frequency of 440. And 3.5.reciprocal will return
the frequency of an event that is 3.5 seconds long. If we also use midicps to convert midi
numbers to frequency we can raise the language level one more step toward our thinking.

midi to cps to delay time
*/

// This will return the duration of each cycle of a wave
// that is the frequency of midi value 69, or A 440

69.midicps.reciprocal;

440.reciprocal; // same thing

// Insert this section into the pluck instrument.

(
{
	var burstEnv, att = 0, dec = 0.001;
	var burst, delayTime, delayDecay = 0.5;
	var midiPitch = 69; // A 440
	delayTime = midiPitch.midicps.reciprocal;
	burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
	burst = PinkNoise.ar(burstEnv);
	CombL.ar(burst, delayTime, delayTime,
		delayDecay, add: burst);
}.play
)

/*

We don't have to use a PinkNoise burst as a noise source. Try other types of noise and other
types of waves. Try mixing down a complex collection of sine oscillators also.


Below is the KSpluck in a SynthDef and then a repeating routine.

KSpluck SynthDef (EnvGen, Env, perc, PinkNoise, CombL, choose)
*/

(
//First load the synth and save to disk
SynthDef("KSpluck",
	{
		arg midiPitch = 69, delayDecay = 1.0;
		var burstEnv, att = 0, dec = 0.001;
		var signalOut, delayTime;
		delayTime = [midiPitch, midiPitch + 12].midicps.reciprocal;
		burstEnv = EnvGen.kr(Env.perc(att, dec));
		signalOut = PinkNoise.ar(burstEnv);
		signalOut = CombL.ar(signalOut, delayTime, delayTime,
			delayDecay, add: signalOut);
		DetectSilence.ar(signalOut, doneAction:2);
		Out.ar(0, signalOut)
	}
).play;
)

(
//Then run this playback task
r = Task({
	{Synth("KSpluck",
		[
		\midiPitch, rrand(30, 90), //Choose a pitch
		\delayDecay, rrand(0.1, 1.0) //Choose duration
		]);
		//Choose a wait time before next event
		[0.125, 0.125, 0.25].choose.wait;
	}.loop;
}).play(SystemClock)
)

//Stop it

r.stop;

/*
The right channel is doubled at the octave (+ 12 in MIDI). Try adding an argument allowing
you to double at other intervals (fifth, fourth, third, etc.) Change the choices of wait time.
Why in this patch did I put two values of 0.125 and one of 0.25? Add postln messages to
check variables. Add a statement that links MIDI pitch with decay time such that high notes
have short decays and low notes long decays.

Listen carefully to each attack and the character of each pitch. It is clearly the same
instrument, yet each note has a slightly different timbre. The character changes because each
time the function "pluckInst" is run a new burst of noise is used, which has a different wave
shape. Traditional presets on synthesizers lack this complexity, which is inherent in natural
instruments.

In the K-S patch the argument midiPitch is set from an array of "legal" pitch choices.
It is then added to an array of octave choices. The variable art (articulation) has replaced
delayDecay because it is used to shorten or lengthen each attack. Notice that the burst
envelope supplies a stereo (array) signal to out. Even though you hear one pitch, the left and
right channel should be slightly different. Also the delayTime is set using a stereo array; the
right an octave higher (MIDI numbers). The entire patch is passed through an RLPF with
LFNoise1 control for the filter sweep. The wait array uses a quick method for biasing
choices: load the dice. Since there are 5 instances of 0.125 and one of 1, then 0.125 will be
chosen about 86% of the time.

Try changing the midiPitch array to various scales: whole tone, diatonic, chromatic,
octatonic, quarter tone, etc. Try adding stereo arrays to other aspects of the patch, e.g.
LFNoise rate or filter cutoff.

K S pluck (EnvGen, PinkNoise, LFNoise1, Out, DetectSilence)
*/

//Load this definition
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


//Then run this routine

(
r = Task({
	{Synth("KSpluck3",
	[
	\midiPitch, [0, 2, 4, 6, 8, 10].choose + [24, 36, 48, 60].choose,
	\art, [0.125, 0.25, 0.5, 1.0, 2.0].choose
	]);
	//Choose a wait time before next event
	[0.125, 0.125, 0.125, 0.125, 0.125, 1].choose.wait;
	}.loop;
}).play(SystemClock)
)

r.stop;



//StringModel

 (
SynthDef("StringModel",
{
    arg delayDecay = 2;
	var burstEnv, pitchArray, delayTime, att = 0, dec = 0.001;
	var out;
	pitchArray = [52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
					52, 59, 52, 60, 62, 64].midicps.reciprocal;
	 delayTime = Select.kr(
			Stepper.kr(Impulse.kr(delayDecay), max: pitchArray.size-1),
			pitchArray);
	burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(delayDecay));
	out = BrownNoise.ar(burstEnv)+PinkNoise.ar(burstEnv*2);
	out = out + CombL.ar(
		out,
		delayTime,
		delayTime,
		delayDecay); //Echo chamber
		Out.ar([0,1],
			Pan2.ar(
					out, 0))
},
[5] //lag time
	).add) //End Ugen function
 )

k = Synth("StringModel", [\delayDecay, 2], target: s);
k.set(\delayDecay, 8);
k.set(\delayDecay, 4);
k.set(\delayDecay, 20);
k.set(\delayDecay, 2);

k.free;

/*
Delays for complexity

Earlier we saw how quickly a simple patch can be fleshed out using multi-channel expansion
or Mix in conjunction with a function and the dup message. In this case they are duplicated at
the same point in time. Delays have a similar effect. They duplicate a patch, but sequentially.
Notice the subtle difference between these two examples. The first creates a single process,
and duplicates it in time. The second creates five independent processes.

Delay to add complexity
*/

(
{
t = Impulse.kr(5);
o = SinOsc.ar(TRand.kr(2000, 4000, t), mul: EnvGen.kr(Env.perc(0.001, 0.1), t))*0.1;
Mix.ar(Pan2.ar(
	CombL.ar(o, 2.0,
		Array.fill(5, {rrand(0.2, 1.9)})
	),
	Array.fill(5, {1.0.rand2})
));
}.play
)

// Compare with

(
{
t = Impulse.kr(Array.fill(5, {rrand(4.0, 7.0)}));

Mix.ar(Pan2.ar(
SinOsc.ar(TRand.kr(2000, 4000, t), mul: EnvGen.kr(Env.perc(0.001, 0.1), t))*0.1,
	Array.fill(5, {1.0.rand2})
));
}.play
)

/*
Does this all seem like a big hassle to get a simple pluck sound? If you think so, then
use the UGen Pluck.

*ar (in: 0, trig: 1, maxdelaytime: 0.2, delaytime: 0.2, decaytime: 1, coef: 0.5, mul: 1, add: 0)

*/

// excitation signal is WhiteNoise, triggered twice a second with varying OnePole coef
(
    {Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(2), 440.reciprocal, 440.reciprocal, 10,
        coef:MouseX.kr(-0.999, 0.999))
    }.play(s)
)
s.quit;
// a group of angry fretless mandolin players
(
    {
        var freq, numparts;
        numparts = 50;
        freq = SinOsc.kr(Array.fill(numparts, {Rand(0.05, 0.2)}),
            Array.fill(numparts, {Rand(0, 1.0)})).range(1000, 3000);
        LeakDC.ar(
            Pan2.ar(
                Pluck.ar(
                    WhiteNoise.ar(0.1).dup(numparts),
                    Impulse.kr(Array.fill(numparts, {Rand(10, 12)})),
                    100.reciprocal, freq.reciprocal, 2, Rand(0.01, 0.2), mul: 1),
                Array.fill(numparts, {Rand.new(-1.0, 1.0)}))
            .sum
            );
        }.play(s);
)