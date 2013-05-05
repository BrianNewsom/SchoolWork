s.makeWindow.boot;

/*
Tutorial 6

Voltage Control, LFO, Envelopes, Triggers, Gates, Reciprocals

Early synthesizer modules had names such as VCO, VCA, and VCF. They are acronyms that
stand for voltage controlled oscillator to control pitch, amplifier to control amplitude, and
filter to control upper harmonic structure. The terms are a bit archaic, but the concepts are at
the core of all synthesis systems and SC patches specifically. Control simply means changing
a parameter. When you turn the volume of your stereo up you are manually controlling the
amplitude parameter. When you press your finger down on the string of a guitar you
manually control the length of the string and therefore the frequency. The vision of electronic
music pioneers was the precision, accuracy, speed, and flexibility one could achieve using
electricity to control these parameters of sound. They realized that the limitations inherent in
humans and many instruments (how high we can sing, how fast we can play, how loud a
piano can play) could be surpassed with electrically generated and controlled sound. They
were right, and today there are virtually no limits to music generated on machines. In fact,
they can easily exceed our ability to perceive.

Voltage control is where one ugen is used to control a parameter or argument of another. We
saw it in the first patch. The LFNoise0 generated values at a given rate and those values were
used as the frequency for the SinOsc. When we used a MouseX to control frequency it was
manual control. Using an LFNoise0 is voltage or mechanical control. Nearly every object in
SC can be "voltage controlled." Some modules allow you to control just one aspect, but most
components allow control over all three; frequency, filter, or amp, so they act as a
combination VCO, VCA, and VCF. The following examples will focus on pitch, or VCO.

One of the easiest controls to conceptualize is a Line.kr. The arguments are starting point,
ending point, and duration. The example below shows a sine oscillator ugen with static
values, then the same patch with the Line.kr ugens in place of the static freq and mul
arguments. Note that the start and end values are appropriate for each control: 0 to 1 for
amplitude and 200 to 2000 for frequency.

 */

{SinOsc.ar(freq: 400, mul: 0.7)}.play

{SinOsc.ar(freq: Line.kr(200, 2000, 10), mul: Line.kr(0.9, 0.01, 10))}.play

/*
Vibrato

One simple application of voltage control is vibrato. Vibrato is a slight oscillating fluctuation
in either the amplitude (in the case of voice) or pitch (in the case of stringed instruments).
String musicians roll the finger forward and backward during vibrato. The actual pitch then
moves between, say 435 and 445, essentially moving in and out of tune about 5 times per
second. In some previous SinOsc patches the frequency argument was a static value (such as
440). For a vibrato we need to replace the static value with some function or ugen that will
change over time smoothly between 335 and 445. The shape of a vibrato is really like a sine
wave: it moves back and forth between two values at a periodic and predictable rate. Could
we use two SinOsc Ugens, the output of one as the freq argument for another SinOsc? Yes, if
it is scaled and offset correctly. Draw a sine wave with 0 in the center, 1 at the top and –1 at
the bottom. Change the 0 to 440, the 1 to 445 and the –1 to 435. Can you calculate what the
scale and offset need to be to achieve those values?

The answer is scale of 5 and offset of 440. Remember that with +/-1 style ugens the offset is
the center value and the scale is the deviation. So 440 is the center value, 5 is the deviation.

There is one other value we need to consider, the frequency of the control source SinOsc.
How often should it move between 435 and 445? About 5 times per second should make a
natural vibrato. So the frequency of the vibrato SinOsc should be 5 Hz. The vibrato patch
then would look like this. I'll use keyword arguments for clarity:


SinOsc as vibrato - modulating oscillator
*/

SinOsc.ar(freq: 5, mul: 5, add: 440)

/*
In the patch below the SinOsc with a frequency of 5 is stored in the variable "vibrato." If we
were to listen to just the vibrato part of the patch we wouldn't hear anything because 5 is not
a frequency what we hear as pitch, and 450 is a value too high for the hardware to convert to
sound. But when it is placed in the frequency argument for the SinOsc then that outer Ugen
actually produces audio we can hear.

Experiment with each of the controls in the vibrato SinOsc above to see how they affect the
sound. Which value affects the speed of the vibrato? Which value affects the depth? This is a
fairly believable vibrato, if a bit crude, manufactured, or flat; like a lot of early electronic
music. Real musicians don't dive right into a vibrato; they usually start with a pure tone then
gradually increase it. Which values would you change, and what values would you use to
make the vibrato more natural?

Vibrato
*/

(
{
	var vibrato;
	vibrato = SinOsc.ar(freq: 5, mul: 5, add: 440);
	SinOsc.ar(vibrato, mul: 0.5)
}.play
)

/*
Theremin

The Theremin was one of the first electronic instruments. It is not technically a voltage
controlled module, since the changes in pitch and amplitude were linked to the motion of a
performers hand (by proximity to two metal antennae, one for pitch, the other for volume).

Below is a virtual Theremin with controls connected to mouse position: up and down for
pitch, left and right for amplitude. You can practically see the spaceship door opening:

Klaatu barada nikto!

Theremin
*/



(
{
var vibrato;
vibrato = SinOsc.kr(6, mul: 0.02, add: 1);
	SinOsc.ar(
		freq: MouseY.kr(3200, 200, lag: 0.5, warp: 1) *
		vibrato, //Vibrato
		mul: abs(MouseX.kr(0.02, 1)) //Amplitude
	)
}.play
)

/*
The mul argument of the control SinOsc will change the depth of the vibrato. If it is set to 0
there is no vibrato, if it is set to 5 it is at a good depth. But both values are static. They don't
change with time as natural vibratos do. In order for the vibrato depth to change over time we
need to replace the static 5 with another time variant control.

There are countless Ugens that will work. For now we can use another Line.kr, (see also
XLine.kr). Here is where it would fit into the patch (this time with variables):

Better vibrato
*/

(
//Vibrato
{
var depthChange, vibrato;
depthChange = Line.kr(0, 5, 3);
vibrato = SinOsc.ar(freq: 5, 	mul: depthChange, add: 440);
SinOsc.ar(
	vibrato,
	mul: 0.5)
}.play
)

/*
Would it be more natural to control the speed (frequency) of the vibrato over time rather than
the depth? What would you change to get such an effect? Could you control both? Could you
also control the overall pitch (i.e. the add value), moving between, say, 300 to 900 using
either a line or another SinOsc?

The vibrato SinOsc and the Line.kr are both "voltage" controls in the classic sense. That is
they are controlling a parameter (frequency) of another ugen. We tried to recreate a natural
sounding vibrato. A violin will rarely exceed a speed of 10 times per second or a depth
beyond 40. But with synthesis, it is easy, even inviting, to go beyond those limits. Try
increasing the mul and the freq arguments to values beyond what you would expect from a
natural vibrato: 33, 100, 1200, etc., for freq, and the same for mul. Try changing the add to
other pitches. Try replacing the add with another control; a SinOsc or a Line. Any static value
can be replaced with a control. Try using controls other than Line. (Calculate the offset and
scale for each carefully so as not to create negative values.) The sounds generated by these
excessive values are unique to synthesis and the electronic age. I’m sure you may be
accustomed to them, because they are so pervasive (a testament to the vision of early
crackpot composers), but imagine hearing them for the first time.

Of the two SinOsc objects one is generating frequencies that we hear. The other is generating
frequencies below audio range (e.g. 10 Hz, 5 Hz). We don't actually hear that sound, but we
do hear the affect it has on the audio range oscillator. Many synthesizers use the term LFO or
Low Frequency Control to describe such an effect. Nearly any oscillator in SC can be used at
LFO rates. Here are several examples using different wave shapes. Experiment with the
frequency, scale, and offset for each LFO. Make sure the offset (add) is greater than the scale
(mul). If the scale is greater you'll get negative values*. Don't exceed 20 Hz for the frequency
of these controls (lest you stumble onto something interesting). We'll cover that later.

*If you create negeative numbers you will hear distorton. If you have a patch
that is otherwise useful but has negative numbers, use the message .abs to
create only positive values.

Other LFO controls
*/

(
{ //SinOsc (sci-fi)
var lfo;
lfo = SinOsc.ar(freq: 10, 	mul: 100, add: 400);
SinOsc.ar(lfo, mul: 0.5)
}.play
)



(
{ //Pulse (phone ring)
var lfo;
lfo = LFPulse.ar(freq: 15, mul: 200, add: 1000);
SinOsc.ar(lfo, mul: 0.5)
}.play
)



(
{ //Saw
var lfo;
lfo = LFSaw.ar(freq: 2, mul: -100, add: 600);
SinOsc.ar(lfo, mul: 0.5)
}.play
)

(
{ //Noise (computer)
var lfo;
lfo = LFNoise0.ar(freq: [28, 27], mul: 1000, add: 2000);
SinOsc.ar(lfo, mul: 0.5)
}.play
)

(
{ //Noise (manic birds)
var lfo;
lfo = LFNoise1.ar(freq: [28, 27], mul: 400, add: 2000);
SinOsc.ar(lfo, mul: 0.5)
}.play
)

/*
Envelopes
The Line ugen in the previous patch is a type of envelope. Envelopes describe a single event
(as opposed to periodically repeating events) that changes over time. Typically they are used
to control amplitude (a VCA), but they can be applied to any aspect of sound such as
frequency, or as in the last patch, the depth of a vibrato.

An envelope in SC has an additional function: when it has ended it can signal the server to
stop playing that ugen and free up the CPU. Without this feature the events in a composition
would add up and eventually max out the CPU. See UGen-doneActions

We all know the amplitude of a musical event decreases over time (this is called decay), but
there is also an attack, which is the beginning of a sound. A marimba has a sharp attack. An
organ has a softer or long attack. A violin may have a short or a very long gradual attack
depending on how the bow is used. A piano has a sharp attack, but not as sharp as a wood
block. The difference may be only a few milliseconds, but it is easy to distinguish between
very small variations in attack time. All presets on all synthesizers use envelopes to describe
the change of volume over time.

There are two types of envelopes. Fixed duration and sustain envelopes. The sections of a
fixed duration envelope will always be the same duration. Fixed envelopes usually have an
attack and a release. The duration of a sustain envelope will change depending on the length
of a gate, e.g. how long a key is held down. Percussion instruments such as cymbals,
marimba, chimes, etc., have fixed duration envelopes. Once they are set in motion you can't
control the duration of the decay. Organs, voice, violins, brass, etc., have sustaining
envelopes, where each note continues to sound until the key is released or the musician stops
blowing or bowing. At that point the pitch dies away.

The most common terms used to describe envelopes are attack, decay, sustain, and release or
ADSR. Simpler envelopes may include only AR, or attack and release.
*/

Env.perc(0.01, 4, 1, -8).plot;

/*
Listen to the following two patches. The first example has no envelope and is
just an annoying sine wave. The patch wraps the timbre in the envelopw shape
in the above example.
*/

(
{
a =	SinOsc.ar(5200, 0, 0.5);// no amplitude envelope
Pan2.ar(a, 0, 0.5) // for stereo
	}
.scope
)

/////tingEnv

(
{var e;
e = Env.perc(0.0, 4.5, 1, -10);
a = SinOsc.ar(5200, 0, EnvGen.ar(e, doneAction:2));//amplitude envelope
Pan2.ar(a, 0, 0.5)
	}
.scope
)


/*
SC uses EnvGen and Env to create envelopes. Env describes the shape of the envelope and
EnvGen generates that shape when supplied a trigger or gate.

Triggers, Gates, messages, ar (audio rate) and kr (control rate)

When you press the key of a consumer synthesizer the first piece of information that is sent
to the processor is a trigger to begin that event. Below are examples of two triggers. The first
is a periodic trigger, the second is a random trigger. The first two examples do not use the
trigger to activate an envelope. Rather they simply play the triggers, which will sound like
pops (not really intended for audio output). They both take one argument. For Impulse it is
the number of pulses per second. For Dust, it is the average density of pulses.

Previously we saw that the mul argument in a SinOsc corresponds with volume. An EnvGen
and Env can be used in conjunction with a trigger to supply events with an envelope for the
mul or amplitude of the SinOsc, as in the third and fourth examples below.

Trigger and envelope
*/

{Impulse.ar(4, mul: 0.5)}.play //periodic trigger

{Dust.ar(5)}.play  //random trigger



(
{
	SinOsc.ar(
		440,
		mul: EnvGen.kr(Env.perc(0.001, 1.0), Impulse.kr(2))
	)
}.play
)

(
{
	SinOsc.ar(
		440,
		mul: EnvGen.kr(Env.perc(0.001, 0.3), Dust.kr(2))
	)
}.play
)

/*
Try changing the arguments for Impulse and Dust. The arguments for Env.perc are attack and
decay. Try changing both. Notice that the decay of a current event is cut off if the next trigger
begins before it can finish its decay.

SinOsc uses the ar message while the ugens Dust and Impulse use kr. The ar stands for audio
rate while kr is control rate. The SinOsc is generating actual audio so it needs to have a
sample rate of 44.1k. But controls that are not heard as audio, but rather shape or trigger
other ugnes, do not need such high resolution and are more efficient if generated at a lower
rate. A SinOsc.kr will generate a sine wave at 1/64th the rate of a SinOsc.ar.

Any positive value will be interpreted by EnvGen as a trigger, as illustrated by the patch
below. A SinOsc moves repeatedly from positive to negative values. When the SinOsc moves
from negative to positive the EnvGen is triggered. In the second example a MouseX is used to
map the X axis of the screen to values between –0.1 and 0.1 (the center of the screen is 0).
When the mouse crosses the middle of the screen a trigger is sent to EnvGen.

Trigger with MouseX
*/

(
{
	SinOsc.ar(
		440,
		mul: EnvGen.kr(Env.perc(0.001, 0.3), SinOsc.ar(2))
	)
}.play
)

(
{
	SinOsc.ar(
		440,
		mul: EnvGen.kr(Env.perc(0.001, 0.3), MouseX.kr(-0.1, 0.1))
	)
}.play
)

/*
The ugen TRand responds to a trigger, returning a random value within a given range. It can
be used as a control source for the frequency argument of a SinOsc.

The example below uses a variable to link several arguments together. The TRand is
generating a new pitch at every trigger. The envelope is also being generated at every trigger,
so they correspond. Also, the decay rate (second argument of Env.perc) is proportional to the
trigger speed, in this case, 1/2. This is done so that each triggered event will decay before the
next is started. If the decay is longer than the duration of the trigger, then the events will
overlap. This is what happens in real life, but I've made this adjustment to illustrate an
application of variables.

Try changing the trigger speed and the attack rate. Notice that the decay is longer when the
trigger is slower. How would you link the duration of the attack to the trigger speed? Can you
expand it to two channels such that the left channel has lower notes and a faster rate, the right
higher notes and a slower rate?


Envelope with trigger
*/

(
{
var triggerSpeed, trigger;

triggerSpeed = 8;
trigger = Impulse.kr(triggerSpeed);

SinOsc.ar(
 TRand.kr(100, 2000, trigger),
 mul: EnvGen.kr(
  Env.perc(0.001, 1/triggerSpeed),
  trigger
 )
)
}.play
)

//same patch with comments

(
{
var triggerSpeed, trigger; //set up some variable names

triggerSpeed = 8; //create 8 notes a second
trigger = Impulse.kr(triggerSpeed); //set the gate for the envelope generator

SinOsc.ar( //sound source
 TRand.kr(100, 2000, trigger), //generate a random float value in uniform
 							   //distribution the low number to the high number
 							   //8 times per second - this is the freq argument
 							   //for SineOsc
 mul: EnvGen.kr( //envelope generator - mul argument for SinOsc
  Env.perc(0.001, 1/triggerSpeed),  //the env argument for EnvGen
  trigger //gate argument for EnvGen - triggers the envelope
 )
)
}.play
)


/*
Duration and Frequency

An event or series of events can be expressed either as duration (how many seconds each
event lasts) or as frequency (the number of events in a given period, e.g. a second). In the
patch above, the trigger speed is a frequency, that is to say it is expressed as a number of
events per second. The decay argument in the Env.perc however is a duration, that is how
long each event lasts. But in this patch the two are connected; the duration must last as long
as each trigger. And each new trigger must occur at the end of each duration. This is common
in patches, so it is important to understand how they relate, how to express frequencies that
are slower than one time per second or durations that are shorter then a second, and how to
convert one to the other. First we have to understand how to express either as a ratio.

In the case of frequency the number of events is the numerator and the time (usually in
seconds) is the denominator. For example, 40 Hz is 40 events in 1 second, or 40/1. When a
frequency is lower than one time per second you can express it as a decimal, such as 0.1. But
you can also continue to use the numerator and denominator method, increasing the
denominator (time) rather than decrease the number of events. For example, 2 Hz is 2 events
in 1 second, or 2/1. 1 Hz is 1 event in 1 second or 1/1, and one event in 5 seconds is 1/5,
therefore 0.2 Hz (0.2 times in 1 second).

For duration, time is the numerator and the number of events is the denominator. An event
that lasts 5 seconds can be expressed as 5 seconds for 1 event, or 5/1. When duration is lower
than a second you can do the same: 5/1 is 5 seconds for one event, 1/1 is 1 second for one
event, 1/2 is one second for two events, each event lasting 1⁄2 second (0.5).

Duration and frequency then are reciprocals. To convert between the two simply swap
numerator and denominator. Take for example the frequency of 40 Hz. What is the duration
of each wave? There are 40 waves in 1 second, or 40/1. The duration of each is the
reciprocal; 1/40 (1 second for 40 events). The duration then of each individual event is 1/40th
of a second.

To convert a duration to a frequency do the same. What, for example, is the frequency of an
event that has a 5 second duration? It takes 5 seconds for 1 event, so that is 1 event in 5
seconds, or a frequency of 1/5 (0.2).

Since SC understands both decimal and fractional notation so its somtimes easier
to always use fractional notation and let SC do the math. So rather than set the frequency of
an LFO to 0.1, just enter 1/10 (one event in ten seconds). 3/5 is 3 events in 5 seconds, 35/41
is 35 events in 41 seconds. If the denominator is 1 (15/1 or fifteen events in one second), you
just drop the 1 and use 15.

Synchronized LFO Control

Expressing frequencies and durations as fractions facilitates synchronization of LFO
frequencies; something that is very difficult on vintage synths. Imagine, for example, six
pitches of a chord, each with a trigger, attack, decay, and duration. If the first has a trigger
rate of 2/1 (2 in one second), the next has 3/1, then 4/1, 5/1, etc., then they will all be synched
up every second. Likewise, triggers of 3/15, 4/15, 7/15, 11/15, etc., will all be in synch every
15 seconds.

The same is true for frequency. If 10 SinOsc ugens have related frequencies, expressed as
ratios, they will be in synch periodically at the interval expressed by the denominator. That
sentence is a mouthful, so here is an example. Five SinOsc's with frequencies of 4/10, 3/10,
6/10, 7/10, will fall back into synch every ten seconds. ( They may appear to synch up every
5 seconds. This is because some of the sine waves will be entering their downward phase.
But they are truly in synch every 10 seconds.)

Synchronized LFOs and Triggers
*/
(
{
SinOsc.ar(SinOsc.ar(4/10, mul: 100, add: 1000), mul: 0.1) +
SinOsc.ar(SinOsc.ar(2/10, mul: 100, add: 1000), mul: 0.1) +
SinOsc.ar(SinOsc.ar(5/10, mul: 100, add: 1000), mul: 0.1)
}.play
)


(
{
var scale = 300, offset = 500;
SinOsc.ar(SinOsc.ar(4/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(7/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(2/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(8/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(6/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(5/3, mul: scale, add: offset), mul: 0.1)
}.play
)


(
{
var scale = 600, offset = 1000, synch = 10;
SinOsc.ar(SinOsc.ar(4/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(7/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(2/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(8/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(6/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(5/synch, mul: scale, add: offset), mul: 0.1)
}.play
)

( // synchronized triggers MAD POLYRYHTHMS
{
var synch = 5;
SinOsc.ar(100, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(3/synch))) +
SinOsc.ar(300, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(7/synch))) +
SinOsc.ar(500, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(5/synch))) +
SinOsc.ar(700, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(2/synch))) +
SinOsc.ar(900, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(9/synch))) +
SinOsc.ar(1100, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(6/synch))) +
SinOsc.ar(1300, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(1/synch))) * 0.1
}.play
)


/*
Frequency and Duration Linked

To link duration (such as attack and decay) with frequency in a patch, assign variables to
each at the beginning of the program.

Duration, attack, decay
*/

var dur, att, dec, trigFreq;

dur = 10; // ten seconds long
att = dur*0.1;
dec = dur*0.9;
trigFreq = 1/dur;

or

freq = 10; // ten in one second
att = 1/freq*0.1;
dec = 1/freq*0.9;
duration = 1/feq;
/*

Gates

A gate is a trigger and duration. (A trigger is a gate with 0 duration.) Triggers are used for
fixed length envelopes. A gate can be used for both fixed and sustaining envelopes, but it is
necessary for sustained envelopes. The duration of the gate defines sustain time.
An organ is a good example of a gated envelope. The "gate" is defined by pressing, holding,
and releasing the keys. When you press the key it takes a little time for the pipe to speak. It
may decay slightly while still holding the key, but eventually settles at a sustain level. It will
remain at that level as long as you hold down the key. When you release the key it may take
some time for the sound to die away.

Env.adsr is a gated envelope. It remains "on" for the duration of the gate. The arguments are
attack, decay, sustain and release. The attack is the length of the initial rise to 1.0. It begins at
the same time as the gate. The decay is the length of time it takes to fall to the sustain phase.
It is in the middle of the gate. Note that sustain is not the length of sustain, but the level at
which the sustain portion remains until the gate is closed. The release is the time it takes to
move from the sustain level back to 0 once the gate is closed. Below is a graph of an adsr. (Note,
I am not using the adsr envelope but am creating a model with a breakpoint envelope.)
*/


//env testadsr this is not using the .adsr envelope, for illustration only
(
var e;
e = Env.new(
		[0.01, 0.9, 0.6, 0.6, 0.0],
		[2, 1, 5, 2],
		[0, 0, 0, 0]);
e.plot;
)



/*
MouseX can be used as a trigger, as seen above, but it can also be a gate. As long as the
MouseX value is in the positive range the gate will remain "open." While the gate is open the
Env.adsr will attack, then decay to and remain at the sustain value for as long as the gate is
open. When the MouseX falls below 0 the gate closes and the Env.adsr releases.

Try changing the values for Env.adsr.

Envelope using a gate
*/

(
{
	SinOsc.ar(440,
		mul: EnvGen.kr(
			//Envelope is attack, decay, sustain level, release
			Env.adsr(0.001, 0.3, 0.2, 2.1),
			MouseX.kr(-0.1, 0.1) //gate
		)
	)
}.play
)

(
{
	SinOsc.ar(
		400 + EnvGen.kr(
			Env.adsr(0.3, 0.4, 0.2, 1),
			MouseX.kr(-0.1, 0.1),
			1000
		),
		mul: 0.5
	)
}.play
)

(
    // strummable 10 string guitar
    // use mouse to strum strings
{
	var pitch, mousex, out;
	// e a d g b e
	pitch = [ 30, 32, 34, 24, 28, 33, 38, 43, 47,52] + 12;
	mousex = MouseX.kr;
	out = Mix.arFill(pitch.size, { arg i;
		var trigger, pluck, period, string;
		// place trigger points from 0.25 to 0.75
		trigger = HPZ1.kr(mousex > (0.25 + (i * 0.04))).abs;
		pluck = PinkNoise.ar(Decay.kr(trigger, 0.05));
		period = pitch.at(i).midicps.reciprocal;
		string = CombL.ar(pluck, period, period, 4);
		Pan2.ar(string, i * 0.2 - 0.5);
	});
	out = LPF.ar(out, 12000);
	out = LeakDC.ar(out);
	FreeVerb.ar(out, 0.8, 0.8, 0.5)
}.play;
)


/*
Finally, LFNoise0 is a random source that wanders between –1 and 1. It can be used to
supply a random gate (random triggers and random sustain times). When it is positive the
gate is open, when it falls below 0 the gate is closed. ( LFNoise1 can also be used. See the
help file for an explanation of the differences.  )


Envelope with LFNoise as gate
*/

(
{
	SinOsc.ar(
		LFNoise0.kr(13, 1000, 1200),
		mul: EnvGen.kr(
			//Envelope is attack, decay, sustain level, release
			Env.adsr(0.001, 0.3, 0.2, 0.1),
			LFNoise0.kr(3) //gate
		)
	)
}.play
)

/*
With even the most sophisticated synthesizers you rarely have envelopes with more than 3 or
4 break points (where the envelope changes direction). Real instruments are capable of much
more complex variations in amplitude. SC allows for this level of complexity with the .new
message. The first two arguments are arrays. The first array contains levels for each break
point, the second array contains durations between each break point. Note that there must be
one more value in the levels array than there is in the times array. This patch uses a complex
envelope to control frequency. The EnvGen creates values between 0 and 1, so it is scaled
and offset using the * and + at the end. The graph below shows the shape of the envelope.


Complex envelope
*/

(
{
SinOsc.ar(
	EnvGen.kr(Env.new(
		[ 0, 0.5, 0, 0.3, 0.3, 0, 0.1, 0, 0.2, 0.3, 0.15, 0.5, 0.25 ],
		[1, 0.5, 0.5, 2, 0.7, 1, 0.3, 0.6, 0.5, 0.8, 0, 0.4])
	) * 1000 + 200
)
}.play
)

// This will plot the array

[ 0, 0.5, 0, 0.3, 0.3, 0, 0.1, 0, 0.2, 0.3, 0.15, 0.5, 0.25 ].plot

/*
Using breakpoint envelopes can be a very powerful tool in SC. These allow an
infinite number of points that can control any number of aspects of your synths.
These include amplitude, pitch, filter settings, index of modulation, tempo, etc.
These envelopes contain three arrays, the breakpoint, the duration between those
points, and the curvature between the points.
*/

(
var e;
e = Env.new(
		[0.01, 0.9, 4.9, 9.9, 0.0]/10, //breakpoint
		[20, 30, 50, 30],  //duration
		[2, 4, 1, -3]);  //curve
e.plot;
)

/*
The following examples will use breakpoint envelopes to change multiple parameters
in a patch thet uses the Ugen PMOsc. This Ugen is a phase modulation sine oscillator pair
and has the following argument list: (carfreq, modfreq, index, modphase, mul, add)

In the first example we will wrap a sound in an amplitude envelope:
*/

(

var ampEnv; //make a variable to store an envelope

ampEnv = Env.new( //make an envelope
		[0.5, 0.09, 0.04, 0.000], //break points for mul
		[0.01, 0.5, 6], //time in seconds between each break point
		[0, 0, -5]); //curve betwee each breakpoint

({ PMOsc.ar(1300, //carrier freq
			550, //modulator freq
			8, //index
			0, //modulator phase
			EnvGen.ar(ampEnv), //mul
			0 //add
		) }.play); //

)

/*
The next example takes the same patch and modulates the index.
*/

(
var index;
var ampEnv;

index = Env.new( //index-Amount of modulation
		[0.1, 20, 8, 0.000],
		[0.01, 0.5, 5],
		[0, 0, -5]);

ampEnv = Env.new(  //amplitude
		[0.5, 0.09, 0.04, 0.000],
		[0.01, 3.5, 6],
		[0, 0, -5]);

({ PMOsc.ar(1300, 550,EnvGen.ar(index), 0, EnvGen.ar(ampEnv)) }.play);
)

//add carrier modulation

(
var index;
var ampEnv;
var cFreq;
index = Env.new( //index
		[0.1, 20, 18, 0.000],
		[0.01, 0.5,5],
		[0, 0, -5]);

ampEnv = Env.new(  //amplitude
		[0.01, 0.1, 0.04, 0.000],
		[3.01, 3.5, 6],
		[0, 0, -5]);
cFreq = Env.new(  //frequency
		[20, 1800, 320, 0],
		[0.01, 3.5, 6],
		[0, 0, -5]);
({ PMOsc.ar(EnvGen.ar(cFreq),
			550,
			EnvGen.ar(index),
			0,
			EnvGen.ar(ampEnv)
	) }.play); //

)



/*
The Experimental Process

Finally, below are examples of bells where the pitch or frequency for each event is chosen
from a range. With many instruments the sustain of an event is short in higher frequencies
and longer for lower notes. This patch demonstrates how to link the duration of each event
with the frequency using a variable. There are a few ugens you haven't seen before. Just read
the help files.

Now you have the essential tools for experimentation and discovery. Synthesis using SC is
understanding the parameters (arguments) of a ugen in a patch, and experimenting with
different kinds of controls. It is often reassuring to me that all synthesis can be broken down
to controls for the three elements of sound: frequency, amplitude, timbre.

The last few chapters presented concepts in the order of my experimental process: I typically
start with a very simple patch, maybe just one oscillator. Then I put together two or three
linked controls. I replace and existing static value with a MouseX to try a range of values.
Then I think about what other control sources I could use to automatically move through
those values. I do the calculation for the offset and scale, then place it in the patch. My final
step is to thicken the patch with duplication, stereo expansion, random values, and mixing.
Feel free to do the same with the patches in this tutorial and the help and example files.

Look at the following evolution of a patch we encountered earlier in this tutorial.

*/

//original patch

(
{
var triggerSpeed, trigger; //set up some variable names

triggerSpeed = 8; //create 8 notes a second
trigger = Impulse.kr(triggerSpeed); //set the gate for the envelope generator

SinOsc.ar( //sound source
 TRand.kr(100, 2000, trigger), //generate a random float value in uniform
 							   //distribution the low number to the high number
 							   //8 times per second - this is the freq argument
 							   //for SineOsc
 mul: EnvGen.kr( //envelope generator - mul argument for SinOsc
  Env.perc(0.001, 1/triggerSpeed),  //the env argument for EnvGen
  trigger //gate argument for EnvGen - triggers the envelope
 )
)
}.play
)

//XLine for TRand arguments and replace SinOsc with Pulse
//This only works because the mul argument is a keyword

(
{
var triggerSpeed, trigger;

triggerSpeed = 8;
trigger = Impulse.kr(triggerSpeed);

Pulse.ar(
 TRand.kr(XLine.kr(40,14000,10), XLine.kr(140,18000,10), trigger),
 mul: EnvGen.kr(
  Env.perc(0.001, 1/triggerSpeed),
  trigger
 )
)
}.play
)

//breakpoint envelope replaces Xline

(
{
var triggerSpeed, trigger, lowEnd, highEnd;

triggerSpeed = 8;
trigger = Impulse.kr(triggerSpeed);

lowEnd = Env.new(
				[40, 40, 14000, 100, 12000, 30],
				[10,10,10,10,10],
				[0,0,0,0,0]);

highEnd = Env.new(
				[140, 140, 18000, 2000, 16000, 40],
				[10,10,10,10,10],
				[0,0,0,0,0]);



Pulse.ar(
 TRand.kr(EnvGen.ar(lowEnd), EnvGen.ar(highEnd), trigger),
 mul: EnvGen.kr(
  Env.perc(0.001, 1/triggerSpeed),
  trigger
 )
)
}.play
)

//make it two two channels using Pan2


(
{
var triggerSpeed, trigger, lowEnd, highEnd;

triggerSpeed = 8;
trigger = Impulse.kr(triggerSpeed);

lowEnd = Env.new(
				[40, 40, 14000, 100, 12000, 30],
				[10,10,10,10,10],
				[0,0,0,0,0]);

highEnd = Env.new(
				[140, 140, 18000, 2000, 16000, 40],
				[10,10,10,10,10],
				[0,0,0,0,0]);



Pan2.ar(
	Pulse.ar(
 		TRand.kr(EnvGen.ar(lowEnd), EnvGen.ar(highEnd), trigger),
 			mul: EnvGen.kr(
  			Env.perc(0.001, 1/triggerSpeed),
  		trigger
 		)),
	FSinOsc.kr(triggerSpeed), 0.5)


}.play
)


//add some delay with a Comb filter

(
{
var triggerSpeed, trigger, lowEnd, highEnd, in1, in2;

triggerSpeed = 8;
trigger = Impulse.kr(triggerSpeed);

lowEnd = Env.new(
				[40, 40, 14000, 100, 1000, 30],
				[10,10,10,10,10],
				[0,0,0,0,0]);

highEnd = Env.new(
				[140, 140, 18000, 2000, 8000, 40],
				[10,10,10,10,10],
				[0,0,0,0,0]);


in1 = Pulse.ar(
 		TRand.kr(EnvGen.ar(lowEnd), EnvGen.ar(highEnd), trigger),
 			mul: EnvGen.kr(
  			Env.perc(0.001, 1/triggerSpeed),
  		trigger
 		));

in2 = Pan2.ar(in1,
		FSinOsc.kr(triggerSpeed),
		1);

CombL.ar(in2, 5, 0.3, 4.5, 0.5)

 }.play
)

//add some reverb with FreeVerb

(
{
var triggerSpeed, trigger, lowEnd, highEnd, in1, in2, in3;

triggerSpeed = 8;
trigger = Impulse.kr(triggerSpeed);

lowEnd = Env.new(
				[40, 40, 14000, 100, 1000, 30],
				[10,10,10,10,10],
				[0,0,0,0,0]);

highEnd = Env.new(
				[140, 140, 18000, 2000, 8000, 40],
				[10,10,10,10,10],
				[0,0,0,0,0]);


in1 = Pulse.ar(
 		TRand.kr(EnvGen.ar(lowEnd), EnvGen.ar(highEnd), trigger),
 			mul: EnvGen.kr(
  			Env.perc(0.001, 1/triggerSpeed),
  		trigger
 		));

in2 = Pan2.ar(in1,
		FSinOsc.kr(triggerSpeed),
		1);

in3 = CombL.ar(in2, 5, 0.3, 4.5, 0.5);

FreeVerb.ar(in3, 0.5, 0.6, 0.5)

 }.play
)



/*
Bells

Play around with these patches

*/


(
//frequency linked to envelope length
  //high notes short, low long

{
var frequency;
Mix.ar(
{
		frequency = rrand(100, 5000);
		Pan2.ar(
			SinOsc.ar(
				frequency,
				mul: EnvGen.kr(
					Env.perc(0.001, 500/frequency),
					Dust.kr(0.05),
					0.2
				)
			),
			rrand(-1.0, 1.0)
		)
	}.dup(100)
)
}.play
)


(
//frequency linked to decay length
  //basically the same code but more compact
  //low notes short, high long
{var frequency;
Mix.ar({
		frequency = rrand(100, 3000);
		Pan2.ar(SinOsc.ar(frequency,
			mul: EnvGen.kr(Env.perc(0.001, frequency/1000),
				Dust.kr(0.05), 0.2)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

(//high notes short, low long
{var frequency;
Mix.ar({
		frequency = rrand(100, 3000);
		Pan2.ar(SinOsc.ar(frequency,
			mul: EnvGen.kr(Env.perc(200/frequency, 0.0001),
				Dust.kr(0.05), 0.2)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

(//low notes short, high long
{var frequency;
Mix.ar({
		frequency = rrand(100, 1000);
		Pan2.ar(SinOsc.ar(frequency,
			mul: EnvGen.kr(Env.perc(frequency/500, 0001),
				Dust.kr(0.05), 0.05)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

//Next assignment is to use envelopes. PUSH PLAY piece/
//use LeakDC
//Explore envgen and env