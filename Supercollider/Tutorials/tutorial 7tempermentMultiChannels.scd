/*
Tutorial 7

Just and Equal Tempered Intervals, Multi-channel Expansion,
Global Variables

As you may know, pure musical intervals are ratios. An octave is 2:1.
That is to say an octave above A 440 is double, or 880. The octave above that is 1760.
Interval inversions are reciprocals: an octave up is 2:1, so an octave down is 1:2. The
intervals we use in western music come from the harmonic series, which are multiples of the
fundamental. If the fundamental pitch (the pitch you hear) is 200 then the harmonic partials
are 200, 400, 600, 800, 1000, and so on. The musical intervals they produce above the
fundamental (the fundamental is the unison, or the pitch itself) are an octave, fifth, octave,
third, fifth, seventh, octave, second, as expressed in the harmonic series.

Harmonic series

For example, if we were to have a low C2 as the fundamental pitch, the first fifth we encounter
is G3, the third harmonic. In order to calculate a G2 (the fifth just above C2) you would multiply
that frequency by 3 (G3) then divide by 2 to move down an octave to G2, or 3/2. Let's say
C2 is 60 Hz (to make the math easy), C3 would be 120, G3 180, G2 would be
one half that: 60 * 3 / 2 = 90.

The fifth harmonic is the first major third in the series and is actually two octaves and a third
(E4) above the funamental. To calculate a third above C2 (E2), first multiply by 5 to get E4,
then divide by 2 for each octave down, a total of 4 for E2: 60 * 5 / 4 = 75.

There are a couple tricks to memorizing interval ratios. An octave is 2:1, fifth is 3:2, fourth is
4:3, third is 5:4, minor third is 6:5, second is 9:8. Notice that all the numerators are one
greater than the denominators. So if you can remember the sequence octave, fifth, fourth,
third, minor third, and second, you can usually reconstruct the ratios (remember 9:8 for a
second).

Also, you can refer to the harmonic series above to locate intervals we use in western tuning
along with their corresponding ratios. The interval between harmonic 1 and 2 is an octave
(2:1), between 2 and 3 is a fifth (3:2), between 3 and 4 a fourth (4:3), 4 and 5 a major third
(5:4), 5 and 6 a minor third (6:5)... but then the system breaks down. What is the interval
between 6 and 7? 7 and 8? Why don't we use them? Should we use them? Between 8 and 9 is
the interval we use for a second (9:8). The last two illustrate the half-step we use between 15
and 16 (16:15). Note also that the interval between harmonics 5 and 8 is a minor sixth (8:5).
A major sixth (5:3) can be found between the 6th and 10th harmonics, a major seventh (15:8)
between 8 and 15, and a minor seventh (9:5) between 9 and 5.

The line of code below will generate the harmonic series from C2 with 16 partials.
*/

{ Blip.ar(65,Line.kr(1,16,10),0.2) }.play;

/*

The patch below allows you to test different intervals. The r = 2/1 represents the ratio of the
second frequency. If f = 400 and r = 2:1 ("two to one"), then f*r is 800, or 400 multiplied by
2 and divided by 1. Even though the division by 1 has no effect I express it this way so that
you can try different ratios to see if they do indeed represent common intervals. Change the r
value to 3/2 (a fifth), 4/3 (a fourth), 5/4, etc. Try 64/45 for a tritone.


Intervals
*/

(
{
	f = 400; //fundamental
	r = 2/1; //ratio for second note in interval
	FSinOsc.ar([f, f*r], mul: 0.6)
}.scope(2)
)

/*
The first argument for FSinOsc (fast sine oscillator) is not a single value but an array with
variables. Remember that an array is a comma-separated list of values within brackets. When
an array is used anywhere as an argument in a message SC expands the entire patch into two
identical patches for each channel. It uses the first value of the array for the left channel and
the second for the right. This wonderful feature is called multi-channel expansion. An array
with more than two values will expand to more channels; as many as your hardware will
handle. SC matches all the arrayed arguments, duplicating where necessary, to create parallel
patches.

A short diversion into multi-channel expansion
*/

//This code

(
{SinOsc.ar(
	LFNoise0.ar([10, 12, 14, 6], 400, [800, 1000]),
	mul: [0.3, 0.5])}.scope(4)
)

//Becomes this in each channel:

(
//channel 1
{SinOsc.ar(
	LFNoise0.ar(10, 400, 800),
	mul: 0.3)}.scope(1)
)

(
//channel 2
{SinOsc.ar(
	LFNoise0.ar(12, 400, 1000),
	mul: 0.5)}.scope(1)
)

(
//channel 3
{SinOsc.ar(
	LFNoise0.ar(14, 400, 800),
	mul: 0.3)}.scope(1)
)

(
//channel 4
{SinOsc.ar(
	LFNoise0.ar(6, 400, 1000),
	mul: 0.5)}.scope(1)
)

/*
Look at the interval patch once more. Because both frequencies are periodic, and are a
mathematical ratio, the destructive and constructive points become an aggregate, and we
"hear" the resulting pattern in the peaks and valleys. Here is the same example with a three
channel arrayed expansion, one with the first frequency, one with the second, then the third
with both added together. If you are playing back on two channels you will only hear 1 and 2.
The third is just for analysis (though it would sound the same). Change the r = 2/1 to other
ratios such as 3/2, 4/3, 5/4, 6/5, 9/8, etc.

Intervals
*/

(
{
	f = 400;	r = 2/1;
	a = SinOsc.ar(f);
	b = SinOsc.ar(f*r);
[a, b, a+b]*0.3
}.scope(3, zoom: 4)
)

/*
With lower ratios there is more constructive interference, so fewer peaks and valleys. With
high ratios there is more deconstructive interference and more peaks and valleys. Even with
complex peaks and valleys we still hear the pattern. Dissonance and consonance are directly
related and can be defined as the number of peaks in a pattern for a given amount of time, or
the amount of time between the peaks that define the pattern. More peaks and valleys; higher
dissonance.

In each of the graphs above, our eyes (brains) recognize the visual pattern, and likewise our
ears pick up on the aural pattern that results from the constructive and destructive
interference.

FYI
In the past few patches you may have noticed I was able to use variables without declaring
them. The letters a-z are global variables, declared when SC launches, and are useful for
quick experiments. Fair warning; you will regret using them instead of more meaningful
names as your patch becomes more complex.

Also notice that the last line of code in the function is simply the array of variables. This last
line is called the “return.” A function “returns” the results of the last line of code regardless
of what happened in the body of the function, as illustrated below.

Function return: last line
*/

( //this code will only play c
{
	a = FSinOsc.ar(200);
	b = FSinOsc.ar(1000);
	c = Pulse.ar(45);
	d = FSinOsc.ar(400);
c;
}.scope(1)
)

/*

The next examples illustrates this concept in real time. The first patch has a sinlge wave
that will move from an LFO to audio frequency. The second patch allows you to move two
pitches from low frequency to audio range. This way you can first hear the pattern as a set
of clicks or pulses in low frequency. With a pulse or saw you hear a single click each period of
the wave when the speaker pops back to its original position. (We hear the separate pulses as
rhythmic patterns of 3/2, 4/3 etc.) Then as you move the mouse to the right, bringing the frequencies
into audio range, you hear the resulting audio interval. First try running the line below to hear
the difference between LFO and audio rates. Move the mouse all the way to the left for low
frequency, to the right for audio frequency.

Audio frequencies
*/

{Saw.ar(MouseX.kr(1, 1200, 1), 0.5)}.scope(1)

/*
The patch below uses two frequencies defining an interval. I've set the ratio to 3:2 using
ratioNum and ratioDenum. Change these to 2:1, 4:3, 5:4, etc. Try non-superparticular ratios
such as 8:3, 7:2. Remember that with higher numbers there will be fewer coincident
constructive interference peaks and we will hear that as a more dissonant interval.

Listen to the pattern and look at the periods in the scope. Next move the mouse slowly to the
right until the frequencies become pitches. Move all the way to the right to confirm that it is
the interval you were trying for.

Ratios from LF to audio rate
*/

(

{//I LIKE THIS
var freq, ratioNum, ratioDenum; //declare two variables
ratioNum = 3; //assign numerator
ratioDenum = 2; //assign denominator
freq = MouseX.kr(1,440, warp: 1); //freq is mouse control
LFSaw.ar(
	[freq, freq*(ratioNum/ratioDenum)], 0,
	0.3)
}.scope(2)
)

/*

Just vs. Equal Intervals

We now have a slight dilemma (or more choices, depending on your outlook). Do we use
pure, just intervals? Or do we use equal temperament? Earlier we used midicps
to convert MIDI numbers to frequencies. But MIDI values are equal tempered. The ratios
we've been experimenting with result in a Just tuning. Which do we use? Do we have to
choose one or the other? Are they really that different?

Yes, they are really that different. Each half step in an equal tempered scale is 100 cents.
MIDI numbers use one integer for each half step, so we can use a precision of two decimal
points to describe the cents. The quarter tone between C4 and C#4, for example, is 60.5 (60 +
50 cents). The lines of code below show how to calculate a major scale using pure ratios,
then convert those frequencies to MIDI values (which show the cents), which can then be
compared to equal tempered values.


Equal Tempered compared to Pure Ratios
*/

(261.6 * [1, 9/8, 5/4, 4/3, 3/2, 5/3, 16/15, 2/1]).round(0.01)

[261.6, 294.3, 327, 348.8, 392.4, 436, 279.04, 523.2].cpsmidi.round(0.01)

/*
The results are 60, 62.04, 63.86, 64.98, 67.02, 68.84, 61.12, 72 for just, or pure ratios,
compared to 60, 62, 64, 65, 67, 69, 70, and 72. The major third is 14 cents flat, and the major
sixth is 16 cents flat.

Let's see how they sound using the low frequency to audio rate experiment. There are two
very important differences in the example below. First, the MouseX no longer has an
exponential warp. This is because MIDI numbers are linear. The frequencies are
automatically converted to exponential values in the midicps message. The next is that the
interval (expressed in half steps) is added to the value in the left speaker, not multiplied as it
was with the ratio.


Ratios from LF to audio rate
*/

(
{//In equal temperment! Still awesome
var midiNum, interval;
interval = 7;
midiNum = MouseX.kr(0.1, 84);
LFSaw.ar(
	[midiNum.midicps, (midiNum + interval).midicps], 0,
	0.3)
}.scope(2)
)
/*
When working with other equal tempered instruments (guitar, piano, MIDI keyboards), you
should use MIDI values. When working with fretless strings or vocals, why not use just
intonation? (Why has no one ever presented this choice to you before? Because before
computers we haven't had instruments precise enough, or flexible enough, to allow the
choice.) Or why not quarter tones, or mean tone, or Chinese Lu scale by Huai Nan Zi, Han
era.

If you tune to successive just intervals, you will encounter pitch drift. If you are adventurous,
you should see this as a challenge, and delve into the world of free just intonation, in which
the drift is accepted as correct.

For the examples below I jump farther ahead in terms of code. You will just have to suppress
your need to understand each detail. This patch plays two simple tones, one in the left, the
other in the right. The left channel is operating with free-just tuning where each interval is
calculated using Pythagorean ratios without regard to any adjustments. The right channel is
using equal tempered intervals. The Pythagorean comma will affect the left channel, and the
frequencies will drift (from the equal counterpart in the right channel). They should be
playing the "same" pitch, and if they were both set to the same tuning, they would. When
they drift apart, this is not because they are making different choices, but because of the
tuning, and because the Pythagorean tuning drifts.

The first example chooses random intervals, the second is just a scale, which illustrates a
little better the pitch shift. When we hear the two together we can tell they are out of tune.
But can you hear the drift if you listen to just the left channel?

Free-Just, and Equal-Tempered Tuning
*/


( //double click to select the entire example
SynthDef("PureTone",
{arg justFreq = 440, equalFreq = 440;
Out.ar(0, SinOsc.ar([justFreq, equalFreq], mul: 0.4)
		*EnvGen.kr(Env.perc(0, 1), doneAction:2));
}).load(s);

Task({
var jfreq = 440, efreq = 69, next = 6, equalInt, justInt;
equalInt = [-10, -8, -7, -5, -3, -1,
	0, 2, 4, 5, 7, 9, 11];
justInt = [9/16, 5/8, 2/3, 3/4, 5/6, 15/16, 1/1,
	9/8, 5/4, 4/3, 3/2, 5/3, 15/8];
	{
	[equalInt.at(next), justInt.at(next).round(0.01)].post;
	Synth("PureTone", [\justFreq, jfreq.round(0.01),
		\equalFreq, efreq.midicps.round(0.01)].postln);
	next = 13.rand;
	jfreq = jfreq*justInt.at(next);
	efreq = efreq + equalInt.at(next);
	if(jfreq < 100, {jfreq = jfreq*2; efreq = efreq + 12});
	if(jfreq > 1000, {jfreq = jfreq/2; efreq = efreq - 12});
	[0.125, 0.125, 0.124, 0.25, 0.5, 1].choose.wait
	}.loop;
}).play(SystemClock);
)

//example with just a scale.

( //double click to select the entire example //Play with this!!!
SynthDef("PureTone",
{arg justFreq = 440, equalFreq = 440;
Out.ar(0, SinOsc.ar([justFreq, equalFreq], mul: 0.4)
		*EnvGen.kr(Env.perc(0, 1), doneAction:2));
}).load(s);

Task({
var jfreq = 440, efreq = 69, next = 0, equalInt, justInt;
equalInt = [-12, 2, 2, 1, 2, 2, 3];
justInt = [1/2, 9/8, 9/8, 16/15, 9/8, 9/8, 6/5];
	{
	[equalInt.wrapAt(next), justInt.wrapAt(next).round(0.01)].post;
	Synth("PureTone", [\justFreq, jfreq.round(0.01),
		\equalFreq, efreq.midicps.round(0.01)].postln);
	next = next + 1;
	jfreq = jfreq*justInt.wrapAt(next);
	efreq = efreq + equalInt.wrapAt(next);
	0.25.wait
	}.loop;
}).play(SystemClock);
)



