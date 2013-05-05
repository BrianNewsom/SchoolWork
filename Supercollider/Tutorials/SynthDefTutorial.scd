
/*
Synth definitions and Patch

In the post window you have probably noticed something like the following.

Synth("temp__889997816" : 1002)

Synth("temp__55084823" : 1000)

Synth("temp__416709051" : 1000)

Synth("temp__644387395" : 1001)


The numbers in quotes are synth definition names followed by colon, then a node number.
These are created automatically each time an example is run. So far we've been using a
backward compatibility (for SC2 users) short cut, allowing SC to create a new arbitrary synth
definition each time a section of code is run. It creates a new synth even if you run the same
example a second time, which is inefficient. It would be better to replay a definition that
already exists.

We have also been stopping each example using command period, which stops all processes.
If the Synth is assigned to a variable you can stop it explicitly with the free message. Run
these two lines separately; again replace the number with any of the numbers you see in the
post window.


stopping a synthDef
*/
a = {SinOsc.ar(rrand(700, 1400), mul: 0.1)}.play


a.free;

/*
We can bypass finding the synth name by assigning the original patch to a variable. We can
also run several examples and stop them separately or one at a time.

playing a synthDef
*/

//Run these one at a time
a = {SinOsc.ar(rrand(700, 1400), mul: 0.1)}.play

b = {SinOsc.ar(rrand(700, 1400), mul: 0.1)}.play

c = {SinOsc.ar(rrand(700, 1400), mul: 0.1)}.play

d = {SinOsc.ar(rrand(700, 1400), mul: 0.1)}.play

//Stop several

a.free; b.free;

//or one at a time

c.free;

d.free

/*
The SynthDef object allows you to give the patch a name and add arguments. An argument is
similar to a variable and is used to pass values to the function. You can set arguments when a
synth is first created or after it is running. The first example below is just the patch in the
style we have been using so far. The next couches it in a synth definition with a name and
arguments.

SynthDef
*/

(//Original patch
{
var rate = 12, att = 0, decay = 5.0, offset = 400;
var env, out, pan;
pan = LFNoise1.kr(1/3);
env = EnvGen.kr(Env.perc(att, decay));
out = Pan2.ar(
			Blip.ar(LFNoise0.ar(rate, min(100, offset), offset),
				(env)*12 + 1, 0.3),
			pan)*env;
out
}.play
)

//SynthDef (naming it) and arguments replace variables

(
SynthDef("SH",
{
arg rate = 12, att = 0, decay = 5.0, offset = 400;
var env, out, pan;
pan = LFNoise1.kr(1/3);
env = EnvGen.kr(Env.perc(att, decay), doneAction: 2);
out = Pan2.ar(
			Blip.ar(LFNoise0.ar(rate, min(100, offset), offset),
				(env)*12 + 1, 0.3),
			pan)*env;
Out.ar(0, out)
}).play
)
/*
Watch the post window when you run this example. You will see that the long number is
replaced by the name "SH."

With SynthDef a few things that were previously done automatically need to be explicit. The
first is assigning an output bus using Out.ar. (More on busses later...) The next is stopping the
patch when it is done playing. We use the envelope to generate the event, but you might have
noticed that the CPU and Ugens remained the same. That is because even though the
envelope terminated the sound we hear, the patch is still running. There are a number of
possible results when the envelope terminates. The default is to do nothing. Changing it to
doneAction: 2 signals the server to deallocate and free up the processing power used for that
ugen when it is done. (To see its importance try commenting out this line of code when
running the examples below. Watch the peak CPU in the synth server add up and eventually
explode.)
*/
UGen Done Actions

A number of UGens implement doneActions. These allow one to optionally free or pause the enclosing synth and other related nodes when the UGen is finished. These include EnvGen, Line, XLine, Linen, DetectSilence and some Demand ugens. For a list, see:  Synth-Controlling-UGens

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

/*
Now that the code is loaded into the server we can run several copies of the instrument with
control values (for the arguments) using set. The arguments are placed in an array with the
syntax symbol, ( a symbol is a word preceded by a backslash: \rate): [\rate, 10, \offset, 200].
Run these lines singly but one right after the other. (SC makes this easy because when you run on
line the cursor moves to the next line. So you can just keep pressing enter.)


Multiple nodes of SH
*/

//Three separate nodes of "SH" with different arugments.
//Run these three lines in sequence then stop.
a = Synth("SH", [\rate, 10, \offset, 200]);
b = Synth("SH", [\offset, 400, \att, 3.0, \decay, 0]);
c = Synth("SH", [\rate, 30, \offset, 2000]);

//Let them die out or run these lines to stop them.
a.free;
b.free;
c.free;

//Changing a parameter of an existing node. Run these lines in sequence.
a = Synth("SH", [\rate, 23, \offset, 30, \decay, 20]);
a.set(\offset, 1000)
a.set(\offset, 300)
a.set(\offset, 800)

a.free;

//Two nodes with arguments
a = Synth("SH", [\rate, 7, \offset, 200, \decay, 20]);
b = Synth("SH", [\rate, 23, \offset, 1200, \decay, 20]);
a.set(\offset, 40)
b.set(\offset, 1000)
a.set(\offset, 800)
b.set(\offset, 600)
a.set(\offset, 1200)
b.set(\offset, 50)

a.free; b.free

/*
You can also set arguments using the argument number followed by value, or string, value,
as shown below.

Syntax for passing arguments
*/

//Same thing
a = Synth("SH", [\rate, 10, \offset, 200]);
a = Synth("SH", [0, 10, 3, 200]);
a = Synth("SH", ["rate", 10, "offset", 200]);

/*
Finally you can indicate a lag time between control changes for a smooth transition.

Transition time between control changes
*/

//SynthDef, arguments, transition

(
SynthDef("SH",
{
arg rate = 12, att = 0, decay = 5.0, offset = 400;
var env, out, pan;
pan = LFNoise1.kr(1/3);
env = EnvGen.kr(Env.perc(att, decay), doneAction: 2);
out = Pan2.ar(
			Blip.ar(LFNoise0.ar(rate, min(100, offset), offset),
				(env)*12 + 1, 0.3),
			pan)*env;
Out.ar(0, out)
},
[0.5, 0.1, 0, 4] //transition for each argument above
).play
)

a = Synth("SH", [\rate, 6, \decay, 20, \offset, 200]);
a.set(\rate, 18);
a.set(\offset, 1000);

/*
We could have changed the parameters in the original patch and run it again. But that would
be less flexible. Using a SynthDef with arguments now allows us to create copies of
instruments with different control values automatically.

Now that we have a synth definition loaded into the server we can send a series of "play"
commands that build on a compositional process. To repeat these commands we will use a
loop.

The loop message repeats a function. Task allows you to pause the loop. (Don't try a loop
without the pause, or at least save your work before you do.) With each loop a new SH is
created with random values as arguments, or controls.



Multiple nodes of SH
*/

(
r = Task({
	{
		Synth("SH", [
		\rate, exprand(3.0, 22.0),
		\decay, rrand(0.5, 15.0),
		\att, [0, rrand(0, 3.0)].choose,
		\offset, rrand(100, 2000)]);
		rrand(1.0, 5.0).wait; //wait time between repetitions
	}.loop; //repeat this function
}).play
)

r.stop;

/*
Try changing any of the values in these examples. Also try inserting postln messages to
monitor values (e.g. rrand(1.0, 5.0).wait.postln).

Finally, once you have honed the instrument down to where it is worth saving, you can write
a copy to disk (synthdefs folder of the SC folder). The next time you launch SC you can just
run the synth by name. (It is important to send it to the correct server, whichever is running.
If you click on the default button of the running server it will go to that server. Or you can
use the target argument to send it to one or the other. I've included the boot expression below
to illustrate the second method.)

Multiple nodes of SH
*/

(//Save to file and load in server "s"
SynthDef("SH",
{
arg rate = 12, att = 0, decay = 5.0, offset = 400;
var env, out, pan;
pan = LFNoise1.kr(1/3);
env = EnvGen.kr(Env.perc(att, decay), doneAction: 2);
out = Pan2.ar(
			Blip.ar(LFNoise0.ar(rate, min(100, offset), offset),
				(env)*12 + 1, 0.3),
			pan)*env;
Out.ar(0, out)
}).send(s)
)

//Now quit SC, look in the synthdefs folder for "SH.scsyndef"

//Launch SC and run these lines

s = Server.internal; s.boot;

a = Synth("SH", [\rate, 10, \offset, 200], target: s);

/*
After you've compiled a nice library of instruments like the KSpluck you will probably forget
what control busses, output busses, and arguments they had. You can look up all that
information using these lines.

SynthDef Browser
*/

(
// a synthdef browswer
SynthDescLib.global.read;
SynthDescLib.global.browse;
)

/*
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
).send(s);
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

Karplus-Strong Patch Examples

In the practice K-S patch the argument midiPitch is set from an array of "legal" pitch choices.
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



Practice: Karplus-Strong Patch

Practice: K S pluck (EnvGen, PinkNoise, LFNoise1, Out, DetectSilence)
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
).send(s);
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


/*
Simplified Examples

Here is a simple SynthDef that will control the frequency and amplitude
of a sine wave. In these examples the SynthDef is loaded into the server
and is waiting for a message to be played.
*/


(
SynthDef("david",
{
arg freq = 220, amp = 0.5;
Out.ar([0, 1], SinOsc.ar(freq, 0, amp, 0))//Out is stereo
}
).send(s)
)

a = Synth("david", [\freq, 220, \amp, 0.5]);

a.set(\freq, 440);
a.set(\amp, 0.7);

a.free;

//add a lag time between arguments

(
SynthDef("sarah",
{
arg freq = 220, amp = 0.5;
Out.ar([0, 1], SinOsc.ar(freq, 0, amp, 0))
},
[2.5, 2.0]//lag time
).send(s)
)

b = Synth("sarah", [\freq, 220, \amp, 0.5]);

b.set(\freq, 440);
b.set(\amp, 0.7);

b.free

/////////////////

(
SynthDef("jiffer",
{
arg rate = 8, scale = 440, offset = 300;
Out.ar([0, 1], Pulse.ar(LFNoise0.ar(rate, scale, offset), mul: 0.5))
},
[5, 5, 5]
).send(s)
)

c = Synth("jiffer", [\rate, 8, \scale, 440, \offset, 300]);
c.set(\rate, 12);
c.set(\rate, 4);
c.set(\scale, 880);
c.set(\offset, 800);
c.set(\rate, 8, \scale, 320, \offset, 380);

c.free;


//Karplus/Strong

 (
SynthDef("StringModel",
{
    arg delayDecay = 2;
	var burstEnv, pitchArray, delayTime, att = 0, dec =0.001;
	var out;
	pitchArray = [52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
					52, 59, 52, 60, 62,
					64].midicps.reciprocal;
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
[5]
).send(s) //End Ugen function
 )

 k = Synth("StringModel", [\delayDecay, 2], target: s);
 k.set(\delayDecay, 8)
 k.set(\delayDecay, 4)
 k.set(\delayDecay, 20)

 k.free;

/*

Patch

Using the Player Patch, we can create GUI players on the cheap. This method of GUI creation has its limitations, as you will see, but is a quick and dirty way to make a GUI with slider controls and node assignments.

First we'll start out with a basic SC patch. (Remember, that patch with a lower case p is a vernacular for a chunk of code, Patch with an upper case P is an object).

*/

(
{var signal;
signal = SinOsc.ar(100, 0, 0.5, 0);
Pan2.ar(signal, 0)
}.play
)

/*

Now we'll make it into a synhDef adding arguments and
.set controls.

*/

(
SynthDef("sine",
{
arg freq = 100, mul = 0.5;
var out, signal;
signal = SinOsc.ar(freq, 0, mul, 0);
out = Pan2.ar(signal, 0);
Out.ar(0, out)
}
).send(s)
)

a = Synth("sine", [\freq, 100, \amp, 0.5]);

a.set(\freq, 440);
a.set(\amp, 0.7);

a.free;

/*
The following code doesn't work in 3.6

With only a few modifications, we can make the SynthDef
into a Patch. Patch by itself does not create the GUI. You
must send the message .gui to the Patch objrct.

*/

(
Patch(
{
arg freq = 100, mul = 0.1;
	var signal;
	signal = SinOsc.ar(freq, 0, mul, 0);
	Pan2.ar(signal, 0)
}
).gui
)

/*

When the GUI is created, click on the green
button ">" and move the sliders. To stop the
synth, click on the "free" button. If you click on
the "quit" button you will quit SC.

Here's a more complex Patch.

*/

(
Patch({|mix =0.33, room = 0.25, damp = 0.7, amp = 0.1, rate = 1| //shorthand args
	var signal;

	signal =	Decay.ar(Impulse.ar(rate), 0.25, LFCub.ar(1200)) ! 2 +
			Pan2.ar(
				Decay.ar(Impulse.ar(rate, pi), 0.1, WhiteNoise.ar),
				LFNoise1.kr(0.5).range(-1,1)
			);

	FreeVerb2.ar(
		signal[0], // Left channel
		signal[1], // Right Channel
		mix, room, damp, amp)

}).gui
)

