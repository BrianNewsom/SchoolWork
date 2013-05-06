s = Server.local.makeWindow.boot;


/*
More on Variables, Comments,  Scale and Offset using Mul and Add

Variables and Comments

It is often useful in code to define and use your own terms and functions. Variables are used
for this purpose. Remember that variable names can be anything but must begin with a lower
case letter (no numbers) and they must be contiguous. It is tempting to use short cryptic
names such as tri, beg, gleep, freq, or even single letters such as a, b, c. More descriptive
names take more time but you will be glad you used them in the long run; firstPitch,
legalDurations, maximumAttack, etc.  DON'T USE S AS VAR A-Z.

Variables are declared (identified to the program) with the syntax var followed by a list of
variables separated by commas and terminated by a semicolon. Variables are assigned values
(the value is stored in the memory location associated with the variable) using the "=" sign
followed by the value you want to store and a semicolon. The variable (or more accurately,
the value contained in the variable) can then be used throughout the program.

The scope of a variable is the function in which it is declared. A variable cannot be used
outside that function. You can declare global variables using the tilde (~). These do not
require the var syntax.

The second example below also introduces expressions. An expression is a line of code
punctuated with a semicolon. It delineates the order of execution; basically "do this;" "then
this;". So the variables are declared first, then three variables are assigned values, then the
SinOsc is put together played.

Variable declaration, assignment, and comments
*/

//First patch

{SinOsc.ar(LFNoise0.ar(10, mul: 400, add: 800), 0, 0.3)}.play

//First patch with variables

(
{

var freqRate, freqRange, lowValue;
freqRate = 10; //rate at which new values are chosen
freqRange = 1200; //the range of frequencies chosen
lowValue = 60; //the lowest frequency

SinOsc.ar(
	LFNoise0.ar(freqRate, freqRange/2, freqRange + lowValue),
	0, 0.3)
}.play
)

/*
One reason for using variables is clarification. Earlier this example required explanation for
arguments in LFNoise0. But variables are self-documenting. By using descriptive names the
programmer can show in the code not only where a value is used but also what they mean.
Variables can also be used for consistency. One variable may be used hundreds of times in a
program or patch. Using a variable ensures that when a change to that value is made, it
affects all related associated parts of the patch.

Another important use for variables is to link arguments. For example, you might want to
reduce the volume when higher frequencies are played and increase the volume with lower
frequencies. You might also want the cutoff for a filter to change in proportion to the
fundamental frequency. You might want the decay rate of an envelope to decrease with
higher frequencies (which is what happens on many instruments). Without a common
variable you would have to change them all by hand. For example, here are two possible sets
of parameters for one sound.

100 //low frequency
0.7 // amp
600 //filter cutoff
2.0 //decay rate

1200 //higher frequency
0.3 //lower amplitude
7200 //higher cutoff
0.1 //decay rate

With a single variable, they can be linked using expressions. When frequency changes, the
other variables change accordingly.

var freq;
freq = 100 //frequency may change
amp = freq/1200 //amp changes as freq changes
cut = freq*600 //cutoff changes as freq changes
rate = 100/freq //decay changes as freq changes

Scale and Offset using Mul and Add

Most Ugens generate values either between 1 and -1 or 0 and 1. Earlier I used the mul
argument to change the amplitude of a wave from +/-1 to +/- 0.5, +/- 0.3, and so on. The
result was a change in amplitude or size of the wave. The mul argument multiplies or scales
the wave. A larger scale means a louder sound, smaller scale quieter.

The add argument offsets the output of a Ugen. It changes the center from 0 to whatever the
add value is. A mul of 0.2 would scale the range from +/–1 to +/–0.2, with a center value of
0. What would be the final result if that scaled output were then offset by 0.5? The middle
value would become 0.5 (0 + 0.5), the bottom would be 0.3 (-0.2 + 0.5) and the top would be
0.7 (0.5 + 0.2). Here are three graphs illustrating how the add and mul arguments change a
SinOsc wave.
*/

{SinOsc.ar}.plot //default values

{SinOsc.ar(440, 0, 0.2, 0)}.plot //scale by 0.2

{SinOsc.ar(440, 0, 0.2, 0.5)}.plot  //scale by 0.2, offset by 0.5

/*

Why would you want to scale a wave? Earlier we learned that values above 1.0 are
inappropriate for amplitude. But you may have noticed the LFNoise in the first example
has a mul value of 400. It normally generates values between –1 and 1. What happens
to those values if they are multiplied, or scaled by 400? They change to +/-400.

It might help to remember any wave or ugen output is just a series of numbers. Here is an
array of numbers roughly describing a sine wave (with a low sampling rate):

 [ 0, 0.31, 0.59, 0.81, 0.95, 1, 0.95, 0.81, 0.59, 0.31, 0, -0.31, -0.59, -0.81, -0.95, -1, -0.95, -0.81, -0.59, -0.31, 0 ]

Notice the values go from 0, to 1, to 0, to -1, then 0. This is very similar to the series of
numbers a SinOsc generates. If those numbers were all multiplied by 500 the result would be:

[ 0, 155, 295, 405, 475, 500, 475, 405, 295, 155, 0, -155, -295, -405, -475, -500, -475, -405, -295, -155, 0 ]

It has the same shape and proportions, but larger values due to the higher scale. If all of those
values were offset by adding 600 the result would be:

[ 600, 755, 895, 1005, 1075, 1100, 1075, 1005, 895, 755, 600, 445, 305, 195, 125, 100, 125, 195, 305, 445, 600 ]

Why offset and scale? This final array of numbers can't be used as an oscillator, because our
speakers only accept values between -1 and 1. But they would be correct for the frequency
input for another ugen, since they have all been scaled and offset to values that are
appropriate for pitch. That is one example of how mul and add are used.

Scale and offset can be confusing because the resulting range of the Ugen output is different
from the actual offset and scale. You use an offset of 0.5 and a scale of 0.2, but the range of
values ends up being 0.3 to 0.7.

The line of code below shows an offset of 300 and scale of 100. But the range is 200 to 400.
In this example a SinOsc is being used as the freq argument for another SinOsc. To
understand how it is being used, first calculate what values are being returned by this inner
SinOsc with a mul of 100 and an add of 300. Rather than the default of 1 to -1, it is scaled to
100 and -100. The offset makes the 100 a value of 400, and the -100 a value of 200. So the range will be 200 to 400. With a freq of 4 this Ugen will move between 200 and 400 four times per second. How will that affect the freq of the outer SinOsc?

The term for this effect is voltage control, which is discussed in more depth later.

Offset and scale with mul and add
*/

{SinOsc.ar(SinOsc.ar(4, 0, 100, 300), 0, 0.3)}.play //Center of Freq =  300, Wideness of Vibrato = 100

/*
Try changing the values of freq, scale, and add to hear how the sound is effected.
*/

(
{var freq, scale, add;
freq = 4;
scale = 100;
add = 300;

SinOsc.ar(SinOsc.ar(freq, 0, scale, add), 0, 0.3)}.scope
)

/*
Add Mouse.kr controls. In the following examples the MouseX will attenuate the amount the
modulating signal. When the freq value is below 20, the oscilator is an LFO, Low Frequency
Oscilator.
*/


/*(
{var freq, scale, add;
freq = MouseX.kr(4, 800);
scale = 100;
add = 300;

SinOsc.ar(SinOsc.ar(freq, 0, scale, add), 0, 0.3)}.scope
)*/

//This will change the width of the modulator
(
{var freq, scale, add;
freq = 4;
scale = MouseX.kr(100, 600);
add = 300;

SinOsc.ar(SinOsc.ar(freq, 0, scale, add), 0, 0.3)}.scope
)

//This will change the center pitch
(
{var freq, scale, add;
freq = 4;
scale = 100;
add = MouseX.kr(100, 1000);

SinOsc.ar(SinOsc.ar(freq, 0, scale, add), 0, 0.3)}.scope
)

/*
Same patch using variables and adding MouseY to the offset.
Try changing the freq to a number in the audible spectrum.
*/

(
{var freq, scale, add;
freq = 4;
scale = MouseX.kr(1, 100);
add = MouseY.kr(220,440);

SinOsc.ar(SinOsc.ar(freq, 0, scale, add), 0, 0.3)}.scope
)



/*

Offset and scale can be even more confusing because some ugens, such as an Env and
EnvGen, or LFPulse, have a default range of 0 to 1 not +/–1. Even more confusing,
Max/MSP has a few objects whose default values are 0.5 and -0.5 (the reasoning of which
escapes me). So the affects of a scale and offset are different (though more straightforward).
An EnvGen that is scaled by 200 and offset by 100 will have final values of 100 to 300. If
this is confusing read this section a few more times. You can't just glance over it and move
on. The concepts of scale and offset are used over and over, not only in SC, but other
synthesis programs.

Here's a useful way to think of scaling in these terms:

For Ugens with a default range of +1 to -1:
–The add is the center value of a range.
–The mul is the amount of deviation above and below the center.
–The lowest value is the add minus the mul.
–The highest value is the add plus the mul.
–The range is the mul times 2.

For Ugens with a default range of 0 to 1:
-The add is the low end of the range
-The mul is the amount of deviation above the low.
-The mul + add is the high end of the range
-The mul is the range

There is a message that can do the calculation for you. It is called range and converts one
range of values to another. The arguments are the low and high range. In most cases it's just
about as easy to do the calculation in your head.

Map a range
*/
(
{
SinOsc.ar(
		SinOsc.kr(4).range(300, 500)
	)
}.scope;
)
/*
FUN

This next example illustrates how variables are used, and how a ugen can be offset and
scaled to values appropriate for a particular control. This patch builds a single sound with 20
sine waves. Without the variable fundamental you would have to enter the frequency of each
wave. But this single variable allows you to generate a series of multiples based on one
frequency. Try changing it to values between 10 and 300. Also try changing the number of
partials. This patch also uses an argument i, which is similar to a variable. It counts each
harmonic as it is created. To link the speed of each flashing harmonic with its number, try
replacing the first argument of the LFNoise1 (6) to i. The results will be high harmonics that
have a fast flashing, and low harmonics that have slow flashing rates. Reverse this with
(partials –i), for fast lows and slow highs.


Harmonic swimming from the examples folder, variable decay bells
*/
(
SynthDef("harmonicSwimming",
{
	arg fundamental, partials, out, offset;
	fundamental = 50;		// fundamental frequency
	partials = 20;		// number of partials per channel (overtones)
	out = 0.0;		// start of oscil daisy chain
	offset = Line.kr(0, -0.02, 60); // causes sound to separate and fade
	partials.do({ arg i;
		out = FSinOsc.ar(
				fundamental * (i+1), 		// freq of partial
				0,
				max(0, 			// clip negative amplitudes to zero
					LFNoise1.kr(
						6 + [4.0.rand2, 4.0.rand2],	// amplitude rate
						0.02, 					// amplitude scale
						offset					// amplitude offset
					)
				),
				out
		)
	});
	out;
		Out.ar([0,1],out)
}).send(s);
)
a = Synth("harmonicSwimming");
a.set(\fundamental, 900);
a.free;

/*

The second example also illustrates how a single variable can be used to link two parameters
together; frequency and decay. Each sine wave has an envelope (covered next chapter) with a
decay time. A random frequency is chosen, and the decay for that frequency is calculated as a
function of the frequency, such that high pitches have a short decay and low pitches have a
longer decay.


Decay rates linked to frequency using a variable. (Low freq; long decay. High freq;
short decay.)

*/

(
{
Mix.fill(15,
{
var freq;
freq = exprand(40, 50);
	Pan2.ar(
		SinOsc.ar(
			freq * LFNoise1.kr(1/6, 0.4, 1),
			mul: EnvGen.kr(
				Env.perc(0, (freq**(-0.7))*100), Dust.kr(1/5))
		), LFNoise1.kr(1/8)
	)
})*0.3
}.play
)

