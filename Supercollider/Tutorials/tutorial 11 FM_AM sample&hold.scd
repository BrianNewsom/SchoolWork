/*
TUTORIAL

FM/AM Synthesis, Phase Modulation, Sequencer, Sample and Hold


In a previous chapter we created a vibrato with voltage control; using one oscillator in low
frequency to control another in audio range. At that time I warned you not to exceed 20 Hz
for the control frequency. Hopefully you didn't take my suggestion and experimented with
higher frequencies. Of course you can have control rates above 20 Hz, but something
unexpected occurs: new frequencies appear above and below the one being controlled. The
sounds you get with a control source above LFO range are similar to tuning a radio. That’s
because you are entering the realm of frequency and amplitude modulation; the same
technology used by am and fm bands on your radio to transmit signals through the air. (It
also sounds surprisingly similar to bird song. Some birds can produce two frequencies that
interact in the same way.)

From LFO to FM
*/

{SinOsc.ar(SinOsc.ar(MouseX.kr(1, 500), mul: 300, add: 800))}.play

/*
What distinguishes am and fm from LFO are upper and lower sidebands. They are additional
frequencies that appear as a product of the two modulated frequencies.

In amplitude modulation there are two sidebands; the sum and difference of the carrier
frequency (the audio frequency that is being modulated) and the modulator frequency (the
frequency that is controlling the audio frequency). A carrier frequency of 500 and a
modulating frequency of 112 could result in two sidebands: 612 and 388. If there are
overtones in one of the waves (e.g. a saw wave being controlled by a sine wave), then there
will be sidebands for each overtone.

AM Synthesis (SinOsc, scope, mul, Saw)
*/

{SinOsc.ar(500, mul: SinOsc.ar(50, mul: 0.5))}.scope(1)

{Saw.ar(500, mul: SinOsc.ar(50,  mul: 0.5))}.scope(1)

{SinOsc.ar(500, mul: SinOsc.ar(MouseX.kr(1, 500).poll(1),  mul: 0.5))}.scope(1)

/*
In the example above the outer SinOsc is the carrier and the inner SinOsc is the modulator.
The sidebands should be 550 and 450. Change the argument 50 to other values to see how it
changes the sound. Replace the 50 with a MouseX.kr(1, 500). As you move the mouse from
left slowly to the right you should hear two sidebands (frequencies); one ascending and the
other descending.

In frequency modulation a similar effect takes place. But with FM many more sidebands can
be generated. The exact number depends on the modulation index. The modulation index is
how far the modulating frequency deviates from the carrier (the amplitude of the modulating
wave). In SC it is a little more difficult to recognize the components of FM synthesis because
both the carrier and modulator frequencies can appear as arguments in a single SinOsc. For
clarity I've used this form: 400 + SinOsc(124, mul: 100). The 400 is the carrier frequency,
124 is the modulator frequency and 100 is the index. (A higher index results in more
sidebands.)

FM Synthesis
*/

{SinOsc.ar(400 + SinOsc.ar(124, mul: 100), mul: 0.5)}.scope(1)

//Same result using add as an offset

{SinOsc.ar(SinOsc.ar(124, 0, 100, 400), mul: 0.5)}.scope(1)

/*
Phase Modulation

With the PMOsc object it is easier to see carrier, modulator, and modulation index, since they
are the first three arguments. Phase modulation controls the phase of the carrier rather than
the frequency. The differences are academic, and the effect is nearly the same as FM. Try
replacing each of the arguments below (400 is the carrier frequency, 124 is the modulator
frequency, 1 is the index in radians) with a MouseX and MouseY to better understand how
they correlate with the sidebands.

PMOsc.ar(carfreq, modfreq, index, modphase, mul, add)

PM Synthesis
*/

{PMOsc.ar(400, 124, 1, mul: 0.5)}.scope(1)

{PMOsc.ar(MouseX.kr(20, 1200), 124, 1, mul: 0.5)}.scope(1)

{PMOsc.ar(400, MouseX.kr(0, 1200), 1, mul: 0.5)}.scope(1)

{PMOsc.ar(400, 124, MouseX.kr(0, 40).poll, mul: 0.5)}.scope(1) //Index = amount we're modulating

/*
The ratio of the carrier and control frequency determine the sidebands and hence the quality
or timbre, the index controls the number of sidebands, i.e. the brightness of the wave.
Different frequencies of the carrier (i.e. changing the carrier while the modulator frequency
and index remain the same) will sound like one instrument with a changing pitch. Different
frequencies of the modulator only will sound like different instruments. Different indexes will
sound like one instrument being filtered. Of course, you can change all three.


Controls for carrier, modulator, and index
*/

(
{PMOsc.ar(LFNoise0.kr(5, 300, 700),// carrier
	134, 4, mul: 0.4)
	}.scope(1)
)

(
{PMOsc.ar(700,
		LFNoise0.kr(5, 500, 700),//modulator
		12, mul: 0.4
	)}.scope(1)
)

(
{PMOsc.ar(700, 567,
		LFNoise0.kr(5, 6, 12),  //index
		mul: 0.4
	)}.scope(1)
)

(
// All three.
{PMOsc.ar(LFNoise0.kr([9, 9], 300, 700),
		LFNoise0.kr([9, 9], 500, 700),
		LFNoise0.kr([9, 9], 6, 12),
		mul: 0.5
	)}.scope(1)
)

/*
The sidebands are the sum and difference of the carrier and modulator wave. Given a carrier
of 400 Hz and a modulator of 50 Hz, the sidebands would be 450, 500, 550, 600, 650, etc.,
depending on the modulation index, and 350, 300, 250, 200, etc., depending on the
modulation index. If the modulation index is high enough to generate negative numbers on
the lower spectrum, they wrap around. A quick SC formula for calculating 30 sidebands
above and below a given frequency would be abs((-30..30)*m+c) where m is the modulator
and c is the carrier frequency. The example above would be abs((-30..30)*50+400).

While it's important to understand how sidebands are produced and what those sidebands are
in relation to carrier, modulator, and index, I have to say I've never had to actually do those
calculations in real life. And by real life I mean my experiments and compositions. What I do
remember are these three things, as they relate to how the sound changes: carrier =
fundamental pitch, modulator = character of the wave, index = number of partials or filter.

A similar result could be achieved through additive synthesis; 20 sine waves each tuned to
the frequencies listed above. A major advantage to FM is efficiency. It uses only two sine
waves to generate literally hundreds of sidebands, which are equivalent to sine waves.
Compare the two patches below, one using phase modulation, the other additive synthesis.
Note the number of ugens and CPU load for each.

Efficiency of PM
*/

{PMOsc.ar(1000, 1367, 12, mul: EnvGen.kr(Env.perc(0, 0.5), Impulse.kr(1)))}.play

(//same result
{
Mix.ar(
	SinOsc.ar(abs((-20..20)*1367 + 1000),
		mul: 0.1*EnvGen.kr(Env.perc(0, 0.5), Impulse.kr(1)))
)}.play
)

/*
The sidebands are heard as overtones of a single pitch. This raises the issue of harmonic and
inharmonic spectra from an earlier chapter. If the sidebands are related by a low ratio, then
they will sound more harmonic. For this reason it is useful to calculate the modulating
frequency as a ratio of the carrier frequency. In the patch below, change the ratio to whole
numbers such as 1, 2, 3, 4, then ratios such as 3/2, 5/4, 8/7, then try numbers such as 2.317,
1.576, etc. A near round value, such as 2.01, will detune a harmonic spectrum slightly. Since
the modulating frequency ratio stays the same we hear a single timbre playing different
pitches. The modulation index is still controlled by the MouseY. Changing the index with
MouseY changes the brightness but not the timbre because it adds and removes sidebands.
The other advantage of a carrier that is a ratio of the modulator is that if the carrier frequency
changes, so will the modulator, and the collection of sidebands will remain the same in
relation to the carrier. The practical result is that we here the same timbre, even though the
pitch changes. Notice I am using MIDI numbers for frequency.


Carrier and modulator ratio
*/

(
{var freq, ratio;
freq = LFNoise0.kr(4, 20, 60).round(1).midicps;
ratio = 2/1;//change this ratio
PMOsc.ar(
	freq, //carrier
	freq*ratio, //modulator
	MouseY.kr(0.1, 10).poll(1), //index
	mul: [0.4, 0.4]
)}.play
)

/*
The next example adds an envelope to control the amplitude of the PMOsc, but it also
controls the modulation index so that the number of sidebands decay as the sound decays.
The TRand is generating values between 36 and 86, appropriate for MIDI. Since the
arguments are integers and not floats, it will return integers, which in terms of MIDI
constrains the pitches to the equal tempered scale. (I'm not avoiding notes between the keys,
just not what I wanted here. Go ahead and change it.). Again, try unusual values for the ratio
to change the character of the instrument.

Envelope applied to amplitude and modulation index
*/

(//Metallic crisp
{var freq, ratio, env, rate = 5, trig;
trig = Impulse.kr(5);
freq = TRand.kr([36, 60], [72, 86], trig).midicps;
ratio = 2;
env = EnvGen.kr(Env.perc(0, 1/rate), gate: trig);
PMOsc.ar(
		freq,
		freq*ratio,
		3 + env*4,
		mul: env
)}.play
)

/*
Stepper Sequencer

In each chapter I have introduced a few common control sources. We used a SinOsc as an
LFO to control the frequency of another SinOsc. We used LFNoise, envelopes, Line, and
other wave shapes as controls. There are two more classic controls I would like to illustrate.
The first is a sequencer. The sequencer moves through a set of values at a given rate or
trigger. This is done using a combination of Select and Stepper.


Stepper		pulse counter

Stepper.kr(trig, reset, min, max, step, resetval)

Each trigger increments a counter which is output as a signal. The counter wraps between min and max.
trig - trigger. Trigger can be any signal. A trigger happens when the signal changes from
non-positive to positive.
reset - resets the counter to resetval when triggered.
min - minimum value of the counter.
max - maximum value of the counter.
step - step value each trigger. May be negative.
resetval - value to which the counter is reset when it receives a reset trigger. If nil, then this is patched to min.

////////////////////

Select				select one output from many sources

superclass: UGen

The output is selected from an array of inputs.

	Select.ar(which, array)
	Select.kr(which, array)


The sequence is defined as an array. The sequencer can be used to control any aspect of
sound. In this example it is used to control frequency using MIDI pitch numbers. You can
use any set of frequencies or midi numbers (i.e. other tunings), or even random frequencies.
You can also fill the array automatically using Array.fill, rand, series, etc., or modify the
array in a number of ways (illustrated  below).


Sequencer (array, midicps, SinOsc, Sequencer, Impulse, kr)
*/

(
var pitchArray; //Declare a variable to hold the array
	//load the array with midi pitches
pitchArray = [60, 64, 62, 65, 64, 67, 69, 71, 72, 70, 71, 69, 70,
				68, 69, 67, 68, 66, 65, 64, 63, 62, 61, 52, 53, 55,
				56, 57, 59, 51, 53, 54, 56, 60, 58, 57, 55, 54].midicps;
{
	SinOsc.ar(
		Select.kr(
			Stepper.kr(Impulse.kr(8), max: pitchArray.size-1),
			pitchArray),
		mul: 0.5)
}.play
)

(
var pitchArray; //Declare a variable to hold the array
	//load the array with midi pitches
pitchArray = Array.rand(24, 100, 2000).postln;
{
	SinOsc.ar(
		Select.kr(
			Stepper.kr(Impulse.kr(8), max: pitchArray.size-1),
			pitchArray),
		mul: 0.5)
}.play
)

/*
You can modify the array using reverse, scramble, or fill. Consider the lines below. First an
array is filled with random numbers between 60 and 84. Array.rand takes three arguments;
first the number of items in the array, then the low and high ends of the random range. Next
we scramble the array and post it. Then reverse it and post it. Last we add 12 to the entire
array and post it.

scramble, reverse (Array.rand, postln, scramble, reverse)
*/

(
var pitchArray;
pitchArray = Array.rand(10, 60, 84);
pitchArray.postln.scramble.postln.reverse.postln;
(pitchArray + 12).postln
)

/*
Here are examples of each process in an actual patch. Try changing the pitch array to a list of
other scale degrees.

(Stepper has an argument to control how it advances through the array. A value of 1 will
move forward one index at a time. If that value is negative, it will move backward one step at
a time. If it is 3, it will move three steps. )


sequencer variations
*/

(//run this many times
var pitchArray;
pitchArray = [60, 62, 64, 65, 67, 69, 71, 72];
pitchArray = [ //pick one of the following
	(pitchArray + rrand(1, 12)).midicps, //transpose
	pitchArray.reverse.midicps, //reverse
	pitchArray.scramble.midicps, //scramble
	Array.rand(12, 36, 72).midicps, //random midi
	Array.rand(12, 100, 1200) //random frequency
	].choose;
{
	SinOsc.ar(
		Select.kr(
			Stepper.kr(Impulse.kr(7), pitchArray.size-1),
			pitchArray),
		mul: 0.5)
}.play
)

// a more interesting example using PM

(
{
var freq, freqArray, ratioArray, indexArray,
	env, rate = 5, trig;
trig = Impulse.kr(rate);
freqArray = [48, 50, 52, 53, 55, 57, 59, 60,
			62, 64, 65, 67, 69, 71, 72].scramble.midicps;
ratioArray = {rrand(1.0, 3.0)}.dup(20);
indexArray = {rrand(1.0, 4.0)}.dup(20);
env = EnvGen.kr(Env.perc(0, 1/rate), gate: trig);
freq = Select.kr(Stepper.kr(trig, freqArray.size-1), freqArray);
x = PMOsc.ar(
		freq,
		freq*Select.kr(Stepper.kr(trig, ratioArray.size-1), ratioArray),
		Select.kr(Stepper.kr(trig, indexArray.size-1), indexArray)
		 + env*4,
		mul: env);
Pan2.ar(x, 0)
}.play
)


/*
Sample and Hold

Sample and hold is another classic synthesis control source available on the old modular
synthesizers. It didn't survive the transition from modular to integrated units. But I think the
effect is worth preserving. The SC equivalent to a sample and hold is Latch.kr.

Latch				sample and hold

Latch.ar(in, trig)


Holds input signal value when triggered.
in - input signal.
trig - trigger. Trigger can be any signal. A trigger happens when the signal changes from
non-positive to positive.



A sample and hold uses a periodic wave as an input. The wave is sampled at regular
intervals. The resulting values are used as a control. It "samples" the wave and "holds" that
value until a new value is sampled. It can be thought of as an analog to digital converter with
a low frequency sampling rate (though technically the wave being sampled is also digital).
The effect is similar to a strobe light or motion picture film taking snapshots of a smooth
process. That smooth process is then quantized into discrete steps.

How is this useful in synthesis? Why would you want to freeze-frame a wave form? Because
typically you sample a periodic wave. The results are constantly evolving patterns.
The process is similar to the wagon wheel affect you see in movies where the frame rate
corresponds in some way to the motion of the wheels. Even though the wheel (source being
sampled) is making smooth complete turns, but because the wheel motion is periodic, that is,
repeating the same motion over and over, the frame rate of the film can make it look like it is
going backwards, or slowly forward, or jumping around.

The idea is that even though the sample rate is too low to accurately represent the true shape
of the wave, patterns will still emerge because the wave is periodic, and the sample rate is
periodic. Imagine for example a saw wave that moves from 0 to 1 once every second,
returning to 0 at each second. If the sample rate for that wave were 10 times per second the
actual values returned would be 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.0, 0.1, 0.2 etc.
The shape of the saw is evident with a sample rate of 10 times per second. But what if the
sample rate were 0.9 times per second (9 samples in 10 seconds)? That is to say the amount
of time between each sample, or strobe flash, is 0.9 seconds. The first value would be 0, then
0.9, but the next, taken 0.9 seconds later, would be 0.8, then 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0,
then 0.9 again, and so on. They look like multiples of 9, but since the saw wave resets to 0
each second the values never go above 1 (like a modulo). So even though the original wave
was an ascending ramp, these samples describe a descending ramp over the space of 10
seconds. ( If this sounds familiar, it is because the same process causes aliasing; ghost
frequencies which occur when a signal is digitized at a sampling rate below the frequencies of
the source. In this case the resulting "patterns" are heard as frequencies. ) If the sample
rate were 1.65, then the actual values returned would be
0, 0.65, 0.3, 0.95, 0.6, 0.25, 0.9, 0.55, 0.2, 0.85, 0.5, 0.15, 0.8, 0.45, 0.1, 0.75, 0.4, 0.05, 0.7, etc.
(i.e. multiples of 1.65 but never above 1). This series isn't even close to the original saw, but
there is a clear pattern, actually, three interleaved patterns.

I like a sample and hold because it strikes a nice balance between variation and repetition.
The sequences that emerge are more varied than a single sequence, but more cohesive than
an LFNoise control.

Try the example below and listen for the shape of the Saw wave in the frequencies. In the
paragraph above I changed the sample rate to produce a different pattern, but in this patch I
change the frequency of the wave being sampled. (Shortening the wave rather than
lengthening the sample time.) The effect on the patterns is the same, but this way the rate
remains the same. I use a MouseX.kr to control the frequency of the sampled LFSaw. It
begins at 0.1, or once every ten seconds and then moves to 20. When the mouse is at the left
of the screen you should hear the shape of the wave in the resulting frequency control. As
you move to the right, you are essentially shortening the sampled wave in relation to the
sample rate, and the smooth ramp will begin to disappear, but there will always be a pattern.
The second example replaces the mouse control with a Line.kr, which illustrates nicely the
gradual transition from one pattern to the next.


Latch-patterned randomness
*/

(
{
SinOsc.ar(
	Latch.kr(
		LFSaw.kr(MouseX.kr(0.1, 20), 0, 500, 600),
		Impulse.kr(10)),
	mul: 0.3 //Volume of sine
)
}.scope(1)
)

(
{
SinOsc.ar(
	Latch.kr(
		LFSaw.kr(Line.kr(0.1, 20, 60), 0, 500, 600),
		Impulse.kr(10)),
	mul: 0.3 //Volume of sine
)
}.scope(1)
)

/*
As the relationship between the frequency of the wave and the rate of sample changes you
hear different patterns, some obvious, others surprising. But any two values will result in
some kind of pattern since both the trigger and the wave are periodic.

The Latch can be used to control amplitude, frequency of modulator or carrier, or index. The
fourth example scales and offsets the control to work with all three. The right channel is
delayed by two seconds for greater variety.

Latch
*/

(
{ // controlling modulator and carrier freq
f = Latch.kr(
		LFSaw.kr(MouseX.kr(1.1, 30), 0, 1000, 1100),
		Impulse.kr(10));
PMOsc.ar(f, f*2, 12, mul: 0.3)
}.scope(1)
)

(
{	// controlling index
i = Latch.kr(
		LFSaw.kr(MouseX.kr(1.1, 30), 0, 5, 5),
		Impulse.kr(10));
PMOsc.ar(300, 356, i, mul: 0.3)
}.scope(1)
)

(
{	// controlling ratio
r = Latch.kr(
		LFSaw.kr(MouseX.kr(1.1, 30), 0, 2.0, 3.0),
		Impulse.kr(10));
PMOsc.ar(300, 300*r, 12, mul: 0.3)
}.scope(1)
)

(
{	// and of course, scaled to control all three
c = Latch.kr(
		LFSaw.kr(MouseX.kr(1.1, 30), 0, 0.5, 0.5),
		Impulse.kr(10));
f = c*1000+200;
o = PMOsc.ar(f, f*(c*3+4), c*5+6, mul: 0.3);
[o, CombL.ar(o, 2, 2)] //Puts right channel 2 sec behind left
}.scope(1)
)

/*
In a previous chapter on intervals we saw that it is the ratio of the two frequencies that
determines the relative complexity or simplicity of the destructive and constructive
interference patterns, and therefore the level of consonance or dissonance. The same is true
for a S&H. The ratio between the frequency of the sampled wave and the sample rate will
determine the patterns. If we linked the two values the same pattern will persist when the rate
is changed. In the patch below try replacing the MouseX with explicit ratios. I find values
around 1.6 to 1.75 are pleasing (the golden mean, in case you forgot, is 1.61803399).

The second example adds one more control so the ratio of the samples will gradually move
through interesting patterns.


Latch sample and speed ratio (Blip, Latch, LFSaw, Impulse, mul)
*/

(
{
var rate, speed, ratio;
rate = MouseX.kr(1, 24);
ratio = 1.61803399;
c = Latch.kr(
		LFSaw.kr(rate*ratio, 0, 0.5, 0.5),
		Impulse.kr(rate));
f = c*1000+200;
o = PMOsc.ar(f, f*(c*3+4), c*5+6, mul: 0.3);
[o, CombL.ar(o, 2, 2)]
}.scope(1)
)

(
{
var rate, speed, ratio;
rate = MouseX.kr(1, 24);
ratio = SinOsc.ar(2/7, mul: 0.2, add: 1.75);
c = Latch.kr(
		LFSaw.kr(rate*ratio, 0, 0.5, 0.5),
		Impulse.kr(rate));
f = c*1000+200;
o = PMOsc.ar(f, f*(c*3+4), c*5+6, mul: 0.3);
[o, CombL.ar(o, 2, 2)]
}.scope(1)
)

/*
Another method for generating interest is to sample a more complex waveform. Even though
it is complex, if it is periodic, patterns in the wave will be evident in the control values. Take
the following wave as an example. Three waves are mixed together to create a more
complex, but still periodic, wave. The first example below shows four waves at 100, 200,
300, and 550 Hz, mixed to one wave. The second part places the mixed wave into a Latch.

Complex Wave as Sample Source (Mix, SinOsc, Blip, Latch, Mix, Impulse)
*/

{Mix.ar(SinOsc.ar([100, 200, 300, 550], mul: 0.1))}.scope(1)

(
//Used in a sample and hold
{
f = Latch.kr(
		Mix.ar(SinOsc.ar([100, 200, 300, 550], mul: 100, add: 110)),
		Impulse.kr(7));
e = EnvGen.kr(Env.perc(0, 0.2), Impulse.kr(7));
PMOsc.ar(f, f*1.25, e*5, mul: e*0.3)
}.play
)

/*
S&H FM

In the example below try an attack of 1/rate and a decay of 0. Try the alternate latchrates, which
move either gradually or stepwise through random values between 1.53 and 1.63. The patch
is expanded to stereo with the [freq, freq * 1.5]. This creates a fifth in the right channel. Try
other intervals such as 1.2, 1.7, 2, 1.25, etc. Uncomment the alternative latchrates, frequency,
and ratios, or add your own.

The key is to find that level of complexity that keeps your interest; that sweet spot where you
can still follow the emerging patterns, yet have enough variety to keep your attention for long
periods of time. Isn't that really what composition is all about; a blend of predictability and
surprise?

The second example does not use an S&H or sequencer (maybe you could add one?), but
illustrates PM. It is a variation on one of James McCartney's original SC2 examples. James
Harkins then ported it to SC3 and I've made further modifications. It generates PM events
with complex ratios, therefore inharmonic spectra (like a crotale) with a collection of
envelopes for amplitude and modulation index.

The code that actually generates crotale events is a routine that uses random functions, but
remember it gets values from a random number generator, as described earlier. Remember
that you can reset the seed of the random number series, reproducing precisely the sequence
of values. The third task does this, and the occasional repetition gives a sense of cognizant
improvisatory gestures. It sends "seeds" periodically, either chosen from the clock (70
percent of the time), or repeating the previous seed (30%). You can think of this task as a
conductor, instructing the performer to either move on to something new (from the collection
of billions of possible gestures) or repeating something you already did.

Try both examples at once. In which case you might want to adjust the overall volume of the
first one.


Sample and Hold, FM
*/

(
{var freq, latchrate, index, ratio, env, rate;
rate = 9;
//rate = XLine.kr(0.1, 9, 20);
latchrate = rate*1.61803399;
// latchrate = rate*LFNoise1.kr(1/7, mul: 0.03, add: 1.6);
// latchrate = rate*LFNoise0.kr(1/3, mul: 0.03, add: 1.6);

index = Latch.kr(
	LFSaw.kr(latchrate, mul: 4, add: 8),
	Impulse.kr(rate)
	);
freq = Latch.kr(
	LFSaw.kr(latchrate, mul: 36, add: 60),
	Impulse.kr(rate)
	).round(1).midicps;
 //freq = 200; //uncomment this line to hear just the index

ratio = 2.01;
//ratio = LFNoise1.kr(1, mul: 2.3, add: 3.0);
// ratio = LFNoise0.kr(1, mul: 2.3, add: 3.0);
// ratio = LFNoise1.kr(1/5, mul: 2.0, add: 5.0);

env = EnvGen.kr(Env.perc(0, 2/rate), gate: Impulse.kr(rate));

PMOsc.ar([freq, freq * 1.5],
		[freq*ratio, freq*1.5*ratio],
		index,
		mul: env*0.5
)}.play
)

// Variation

(
{var freq, latchrate, index, ratio, env, rate;
rate = 9;
latchrate = rate*LFNoise0.kr(1/10, mul: 0.03, add: 1.6);
index = Latch.kr(
	LFSaw.kr(latchrate, mul: 5, add: 6),
	Impulse.kr(rate)
	);
freq = Latch.kr(
	LFSaw.kr(latchrate,
		mul: max(0, LFNoise1.kr(1/5, 24, 10)),
		add: LFNoise0.kr(1/7, 12, 60)),
	Impulse.kr(rate)
	).round(1).midicps;
ratio = LFNoise1.kr(1/10, mul: 2.0, add: 5.0);

env = EnvGen.kr(Env.perc(0, LFNoise0.kr(rate, 1, 1.5)/rate), Impulse.kr(rate),
LFNoise1.kr([5, 5], 2, 1).max(0).min(0.8));
PMOsc.ar(
	[freq, freq * 1.5],
	freq*ratio,
	index,
	mul: env //overall volume
)}.play
)


// Crotale
// Run this code first to define the instrument,
// then execute the "task" below as many times
// as you want.

(
SynthDef("crotale", {
arg param = #[500, 3, 2, 0, 6, 5, 0, 0.9];
var factor, env, out, freq, index, dur;
var bus, ratioa, ratiob, attack, decay, panCont;
freq = param.at(0); index = param.at(1); dur = param.at(2);
bus = param.at(3); ratioa = param.at(4); ratiob = param.at(5);
attack = param.at(6); decay = param.at(7);

env = Env.perc(attack, decay);
factor = gcd(ratioa, ratiob);
ratioa = div(ratioa, factor);
ratiob = div(ratiob, factor);

panCont = (EnvGen.kr(env, timeScale: dur*1.1,
	levelBias: -1, levelScale: 2))
			* (IRand(0, 1) * 2 - 1);  // 0*2-1 = -1, 1*2-1 = 1

out = PMOsc.ar(
	ratioa*freq, //or try ratioa*freqCont,
	ratiob*freq, //or try ratioa*freqCont,
	pmindex: EnvGen.kr(env, timeScale: dur,
		levelBias: 1, levelScale: index),
	mul: EnvGen.kr(env, timeScale: dur, levelScale: 0.3));

out = Pan2.ar(out, panCont);

out = out * EnvGen.kr(env, timeScale: 1.3*dur,
	levelScale: Rand(0.1, 0.5), doneAction:2);
Out.ar(0, out); //Out.ar(bus, out);

}).play;
)

// Define the instrument by running the code
// above, then run this task to actually play
// the instrument.

(
r = Task({
	var freq, indexDepth, indexRange, synthIndex, dur, repeat;
	var next, count, countDown, offset, ratioa, ratiob, envs, env;
	var range = 60, outBus = 0;
	count = 0; countDown = 0; offset = 0;
	envs = [[0, 0.9], [0.01, 0.9], [0.1, 0.8], [0.8, 0.01]];
	repeat = Array.fill(10,
		{[rrand(range, range+24).round(1).midicps, 3,
			2.1 - exprand(0.1, 2.0), 0, 1, 1, 0, 0.9]});
	next = Array.fill(10, {[3, 0.75, 0.5, 0.25, 0.125].choose});
	freq = rrand(range, range*2); // these two are just starting points
	indexDepth = 1;

	inf.do({
		if(countDown <= 0,
			{
			env = envs.choose;
			next.put(count%10, [3, 0.5, 0.25, 0.125, 0.125].choose);
			repeat.put(count%10, [
				rrand(range, range + 24).round(1).midicps,
				rrand(0.1, 12.0),
				2.1 - exprand(0.1, 2.0), outBus, rrand(1, 12),
				rrand(1, 12), env.at(0), env.at(1)]);
			});

			Synth("crotale").setn(\param, repeat.wrapAt(count));
			next.wrapAt(count).wait;
			if((count > 10).and(countDown <= 0),
				{offset = countDown = [0, 3.rand, 6.rand].choose;
				count = count - offset});
	count = count + 1;
	countDown = countDown - 1;
	});
}).play(SystemClock);
)

