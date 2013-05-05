s = Server.local.makeWindow.boot

/*
Keyword Assignment, MouseX.kr and MouseY.kr, Linear and Exponential values
Keyword Assignment
In the previous examples we included most of the arguments for each message. If any argument
is not supplied, a default is used. Below there are no arguments for the SinOsc, but it still
works. It uses default values of 440, 0, 1, and 0 for freq, phase, mul, and add.

Defaults
*/
(
{SinOsc.ar}.play
)
/*

You might have also noticed that in previous patches we entered a 0 for the phase argument
even though the default value for phase is 0. This is because the arguments have to be entered
in the correct order. Phase is the second argument and mul is the third. We had to enter the 0
as a sort of place marker so that the mul would be in the correct position.

This becomes a problem if there are 10 arguments and you want to change only the sixth
value. You would have to enter arguments 1-5 just so the sixth argument is in the correct
position. This is not only cumbersome, but prone to error.

The alternative solution is keyword assignment. Using keywords you can specify the name of
the argument you are changing followed by a colon and the value. Keywords can be found in
the documentation files. The documentation for SinOsc.ar shows: SinOsc.ar(freq, phase, mul,
add). The keywords are freq, phase, mul, and add. Using keywords not only allows you to
enter a single argument out of order, but to mix the order of the arguments. Here are several
versions of the SinOsc example written using keywords. All of them have precisely the same
meaning.



keywords
*/
(
{SinOsc.ar(freq: 440, phase: 0, mul: 0.4, add: 0)}.play;
)

(
{SinOsc.ar(phase: 0, freq: 440, add: 0, mul: 0.4)}.play;
)

(
{SinOsc.ar(freq: 440, mul: 0.4)}.play;
)


/*
Another good reason for using keywords is clarity. The keyword provides a short explanation
of what each value means, like a short comment.

The last reason for using keywords is portability. Earlier I said it is important to understand
that argument lists are not interchangeable. Consider these two lines: Saw.ar(100, 500, 600)
and SinOsc.ar(100, 500, 600). The arguments for Saw are freq, mul, and add. But for SinOsc
they are freq, phase, mul, and add. So the two lists are not interchangeable. I can certainly use
100, 500, and 600 as arguments for the SinOsc, but they don't mean the same thing as
they did with the Saw. A phase of 500 makes no sense, and a mul of 600 without an add will
produce negative values, probably not what I want.

But if I use keywords (and provided the two Ugens have the same keywords), then I can
swap the objects: SinOsc.ar(freq: 100, mul: 500, add: 1000) and Saw.ar(freq: 100, mul: 500,
add: 1000) will have a similar effect in a patch. Warning: this can be either dangerous or a
source of serendipity. You should always double check the keywords and understand what
they mean in a patch. If a keyword is incorrect it is ignored, but you do get a warning posted
to the post window.

*/

(
{
	SinOsc.ar(
		freq: SinOsc.ar(
			freq: 15,
			add: 500,
			mul: 20
		),
		add: 0,
		mul: 0.4,
		phase: 0
	)
}.play
)

/*
MouseX.kr and MouseY.kr - MouseButton

In the examples above we changed each value, then ran the code, then changed the value and
ran the example again. You may have wished you could attach some type of knob to the
patch so that you could try a range of values at once. This is what MouseX.kr and MouseY.kr
will do. They link mouse movement and position to values that can be used in the patch. The
first three arguments are: minval, maxval, warp.

These ugens can replace any static value with a range of values that change in real time in
relation to the position of the mouse on the screen. As an illustration, try the first patch
reproduced below with a MouseX in place of the first argument for LFNoise0.

MouseX (LFNoise0, SinOsc, mul)
*/
(
{SinOsc.ar(LFNoise0.ar
	(MouseX.kr(1, 50), 500, 600), mul: 0.5)}.play;
)


//Add MouseY to the add argument
(
{SinOsc.ar(LFNoise0.ar
	(MouseX.kr(1, 50), 500, MouseY.kr(50, 10000)), mul: 0.5)}.play;
)

/*
If you want to see the values that the mouse is triggering, send the message .poll and the values will
appear in the post window.
*/

(
{SinOsc.ar(LFNoise0.ar
	(MouseX.kr(1, 50).poll, 500, MouseY.kr(50, 10000).poll), mul: 0.5)}.play;
)


/*
Much easier than changing, trying, changing, trying, etc.

In the example below MouseY (Y axis is top to bottom) is used to control amplitude. The
minval is 0.9 and maxval is 0.0. These may seem backwards, but the minimum position for
the mouse is actually the top of the screen, the maximum is the bottom, and it makes more
sense to me to have the top of the screen 0.9. The next example adds a MouseX to control
frequency. The minimum value is A 220 and the maximum is two octaves higher, or 880.
Since the motion of the mouse spans two octaves you might be able to play a tune using the
mouse to find each pitch. First try an octave, then a fifth, then a scale. See if you can play a
simple tune, such as Mary Had a Little Lamb.

MouseY controlling amp and freq
*/
(
{SinOsc.ar(440, mul: MouseY.kr(0.9, 0))}.scope;
)

(
{SinOsc.ar(MouseX.kr(220, 880), mul: 0.3)}.scope;
)

/*
 One reason it may be difficult to pick out a melody is that the distance between
pitches does not seem consistent across the screen. Since this is two octaves you might
expect the first octave to be in the middle of the screen, but you actually encounter it about a
third of the way, then the second octave spans the remaining two thirds. (Note that with
violins, violas, trombones, etc., there is a similar distribution, but the opposite direction. That
is, the distance between similar intervals decreases as you go higher on the fingerboard.)

The truth is, the distances are consistent; they are linear. The problem lies in our perception
of pitch. We hear music in octaves, and octaves are exponential, not linear. The amount of
change between one of the low octaves (such as 110 to 220) is smaller (110) in comparison
to a higher octave (1760 to 3520; a change of 1760). With a linear range of 220 to 880 the
middle of the screen will be 550. But if we want the screen to visually represent a musical
scale the middle should be 440, the left half for pitches between 220 and 440 (a difference of
220) and the right half should be 440 to 880 (a difference of 440). This more logical tracking
can be implemented using the warp parameter. The warp value is set using a symbol (a word
in single quotes), either linear or exponential. You can also enter the number 0 for linear or 1
for exponential. Try playing a melody or major scale with the following adjustments. You
will notice that with an exponential warp the whole and half-steps seem to be the same
distance all across the screen.


exponential change
*/

(
{SinOsc.ar(MouseX.kr(220, 880), mul: 0.3)}.play;
)

(
{SinOsc.ar(MouseX.kr(220, 880, 'exponential'), mul: 0.3)}.play;
)

/*
As a general rule you will want to use exponential values when dealing with frequency.
I introduce MouseX and Y as a tool for trying values in patches and experimenting in real
time, but it is reminiscent of one of the earliest (and very successful) electronic instruments;
the Theremin. The Theremin controlled pitch and amplitude by proximity of the performer's
hand to an antenna and protruding loop. Performers "played" the Theremin by moving their
hands closer or farther away from the antenna or loop.

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


sci-fi computer (MouseX and Y)
*/

(
{
	SinOsc.ar(
		freq: SinOsc.ar(
			freq: MouseX.kr(100, 1000),
			mul: MouseY.kr(100, 1000),
			add: LFNoise0.kr(
				freq: MouseX.kr(1, 12),
				mul: MouseY.kr(30, 1000),
				add: 600
			)
		),
	mul: 0.6
	)
}.play
)




/*
Discrete Pitch Control, MIDI

The second reason you may have found it difficult to play a simple tune using the MouseX
patch is that the pitch change was continuous. We are accustomed to hearing and playing
instruments with discrete pitches. As a matter of fact, with instruments that allow continuous
pitch change (e.g. violin, voice, trombone) it is usually considered good technique to perform
pitches with precise discretion; no scooping or sliding.

One method for generating discrete pitches would be to use a round message. Try the
example below to see if it is easier to play a tune.
*/

{SinOsc.ar(MouseX.kr(220, 880, 1).round(10), mul: 0.3)}.play

{SinOsc.ar(MouseX.kr(220, 880, 1).round(100), mul: 0.3)}.play

/*

That gives us discrete notes, but they don't seem right, and for the reason we discussed
earlier. Musical scales do not track to linear values. The round(100) gave us values such as
400, 500, 600, and so on. But a chromatic scale, beginning at 220, is 220, 233.1, 246.9,
261.6, 277.2, 293.7, 311.1, 329.6, 349.2. Do all the math you want, the pattern between each
pitch is not going to readily emerge. That's because these are not only exponential values, but
based on the equal tempered scale (which we discuss in a later chapter). We have bumped up
against the pervasive problem of interface; we think of pitches and scales as numbers (if C4
is 0, then E4 is 4 piano keys higher), but the SinOsc only understands frequency.

Fortunately there is a method for generating the frequency of an equal tempered scale by way
of MIDI. SC understands MIDI numbers, and can convert them to frequency. By way of
review; the MIDI number for C4 is 60, and each half-step is 1. To convert these to frequency,
use the midicps message.

[57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71].midicps.round(0.1);

Now back to the original MouseX control patch, with even more confusion. We can now
express the two octave range using the MIDI numbers 57 (A3, or 220 Hz) to 81 (A5, or 880
Hz). But wait, are you a step ahead of me? Do you use a linear warp, or exponential warp? In
this case, linear, because MIDI values are linear. That is to say the difference between the
first octave (57 to 59) is the same as the second (59 to 81): 12.

The first version of this improved patch appears to have correct tracking with pitches, but the
values are not discrete. That is because the MouseX will still return fractions, that is values
between the MIDI pitches, such as 62.1453 or 74.874. To force them to be discrete, we add
the round message, which rounds them to 1. (Try 0.5 and 2.0 for quarter tone and whole tone
scales).

The message .poll will post the value of the Mouse position.

*/

{SinOsc.ar(MouseX.kr(59.0, 81.0).poll.midicps, mul: 0.3)}.play

{SinOsc.ar(MouseX.kr(59.0, 81.0).poll.round(1.0).midicps, mul: 0.3)}.play

/*
Still not happy? Is it because this is a chromatic scale and you want a diatonic scale? For that
I'll refer you to DegreeToKey, a discussion of which is beyond this chapter.
*/

DegreeToKey		convert signal to modal pitch

DegreeToKey.ar(bufnum, in, octave, mul, add)

The input signal value is truncated to an integer value and used as an index into an octave repeating table of note values. Indices wrap around the table and shift octaves as they do.

bufnum - index of the buffer which contains the steps for each scale degree.
in - the input signal.
octave - the number of steps per octave in the scale. The default is 12.

(

// mouse x controls discrete pitch in dorian mode
var scale, buffer;
scale = FloatArray[0, 2, 3.2, 5, 7, 9, 10]; // dorian scale
buffer = Buffer.alloc(s, scale.size,1, {|b| b.setnMsg(0, scale) });

play({
	var mix;

	mix =

	// lead tone
	SinOsc.ar(
		(
			DegreeToKey.kr(
				buffer.bufnum,
				MouseX.kr(0,15),		// mouse indexes into scale
				12,					// 12 notes per octave
				1,					// mul = 1
				72					// offset by 72 notes
			)
			+ LFNoise1.kr([3,3], 0.04)	// add some low freq stereo detuning
		).midicps,						// convert midi notes to hertz
		0,
		0.1)


})
)

//say om...

(
// modal space
// mouse x controls discrete pitch in dorian mode
var scale, buffer;
scale = FloatArray[0, 2, 3.2, 5, 7, 9, 10]; // dorian scale
buffer = Buffer.alloc(s, scale.size,1, {|b| b.setnMsg(0, scale) });

({
	var mix;

	mix =

	// lead tone
	SinOsc.ar(
		(
			DegreeToKey.kr(
				buffer.bufnum,
				MouseX.kr(0,15),		// mouse indexes into scale
				12,					// 12 notes per octave
				1,					// mul = 1
				72					// offset by 72 notes
			)
			+ LFNoise1.kr([3,3], 0.04)	// add some low freq stereo detuning
		).midicps,						// convert midi notes to hertz
		0,
		0.1)

	// drone 5ths
	+ RLPF.ar(LFPulse.ar([48,55].midicps, 0.15),
		SinOsc.kr(0.1, 0, 10, 72).midicps, 0.1, 0.1);

	// add some 70's euro-space-rock echo
	CombN.ar(mix, 0.31, 0.31, 2, 1, mix)
}.play)
)




/*
MouseButton

You can also use MouseButton.kr to control parameters in a patch. The arguments are: minval, maxval, lag

(Use the left button)

*/

{SinOsc.ar(MouseButton.kr(400, 1600, 0.1), 0, 0.1) }.play;

{SinOsc.ar(MouseButton.kr(400, 740, 2), 0, 0.1) }.play;

(
{SinOsc.ar(LFNoise0.ar(MouseButton.kr(1, 50, 5), 500, 600), mul: 0.5)}.play;
)

/*
There are other methods for linking an external control to a value in a patch. You can use
TabletX, TabletY, and TabletZ if you have a Wacom input device. You can also link controls
to an external MIDI control surface or keyboard. You can attach actions to the computer
keyboard (keystate) or build a GUI with sliders and buttons. The code required for each of
these methods is a bit too involved for this section of the text. For now I would like to focus
on internal automatic controls.



MORE FUN! *************************************************************************

The patch below uses only two SinOsc and one LFNoise0, but can generate very rich sounds
because of the way they are linked together (frequency modulation, covered later).
There are four mouse controls and the arguments for the patch are taken from the mouse
position. Use the mouse position to explore sounds. Try the four corners first, then some
spots in the middle.

Try changing the high (12) and low ([1, 1]) ranges for the MouseX, which control the rate of
change, or the high (1000) or low (30) for MouseY, which changes the range of pitches. The
only difference between the third and fourth examples is the exprand (exponential random
values) and rrand (linear random values). Notice that with the rrand it seems most of the
pitches are high, while the exprand seems to space them evenly across the spectrum. This
shows that we hear an exponential increase as being "even" and linear as being biased toward
high values.

*/
(
{
PMOsc.ar(
   LFNoise1.kr(
     MouseX.kr([1, 1], 12),
     mul: MouseY.kr(10, 1000),
     add: 1000),
   LFNoise0.kr(
     MouseX.kr([1, 1], 12),
     mul: MouseY.kr(30, 1000),
     add: 1000),
   MouseY.kr(0.1, 5.0),
     mul: 0.3)
}.play
)

(
// exponential random
{Mix.fill(12, // number of oscillators
 {arg i;
 Pan2.ar(SinOsc.ar(SinOsc.ar(
   freq: MouseX.kr(rrand(0.1, 5.0), rrand(3.0, 20.0)), // speed of vibrato
   mul: MouseY.kr(10, 50), // width of vibrato
   add: exprand(200, 5000)), // freq of oscillators
  mul: max(0, LFNoise0.kr(MouseX.kr(rrand(1, 6), rrand(6, 1))))), 1.0.rand2)
})*0.03
}.play
)

(
// linear random waves
{Mix.fill(12, // number of oscillators
 {arg i;
 Pan2.ar(SinOsc.ar(SinOsc.ar(
   freq: MouseX.kr(rrand(0.1, 5.0), rrand(3.0, 20.0)), // speed of vibrato
   mul: MouseY.kr(10, 50), // width of vibrato
   add: rrand(200, 5000)), // freq of oscillators
  mul: max(0, LFNoise0.kr(MouseX.kr(rrand(1, 6), rrand(6, 1))))), 1.0.rand2)
})*0.03
}.play
)



/*
Even More Fun!

Practice with the patches we have used so far as well as the examples below. Add mouse controls to various arguments and see what happens. Explore the help files for the UGens you aren't familiar with. Try recording to the hard drive and open your sound file in Audacity and proTools.
*/




(
// moto rev
{
	RLPF.ar(LFPulse.ar(SinOsc.kr([0.2, 0.5], 0, 10, 21), 0.1), 100, 0.1).clip2(0.4)
}.scope
)



// Harley Davidson Electro Glide
(
{
	RLPF.ar(LFPulse.ar(SinOsc.kr([0.2, 0.5], 0, 10, 21), 0.1), 100, 0.1).clip2(0.4)
	+
	RLPF.ar(LFPulse.ar(SinOsc.kr([0.3, 0.6], 0, 10, 21), 0.1), 100, 0.1).clip2(0.3)
	+
	RLPF.ar(LFPulse.ar(SinOsc.kr([0.1, 0.4], 0, 10, 21), 0.1), 100, 0.1).clip2(0.2)
}.scope
)

/////////////////////////

(
// LFO modulation of Pulse waves and resonant filters
{
	CombL.ar(
		RLPF.ar(LFPulse.ar(FSinOsc.kr(0.05,0,80,160),0,0.4,0.05),
		   FSinOsc.kr([0.6,0.7],0,3600,4000), 0.2),
		0.3, [0.2,0.25], 2)
}.play
)


//////////////////////////////////////////////////////////////////////////
(
{
({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14)
* 400 + 500, 0.03, 0.003)}!2)
+ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20)
* 800 + 1000, 0.03, 0.005)}!2)
* 4
}.play
)

