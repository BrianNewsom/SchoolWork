s.makeWindow.boot;

/*
Tutorial 8

Additive Synthesis, Random Numbers, CPU usage
Harmonic Series and Wave Shape

Why, after nearly 50 years of electronic music and instrument design, can we still tell if an
instrument is synthesized? What most synthetic models lack are complexity and chaos. Even
sampled instruments do not sound real because an exact duplication of a single note from any
instrument is not a true representation of that instrument, rather a single instance of many
possibilities. A single high resolution digital photo of a leaf duplicated hundreds of times
would not look like a tree. All the leaves on a tree are different, and they change in real time.
The same is true for a piano. Each key has its own harmonic fingerprint. Even the same key
when struck successively will produce different partials depending on the position of the
vibrating string when it is struck. Real instruments are complex and chaotic. Each note is
unique. Though the general upper harmonic content remains constant, the small details
change. SC is a real-time synthesis package that is capable of, even invites and encourages
this level of complexity. We will start the theory of synthesis with the
most intricate and computation intensive method (and most rewarding in terms of results);
additive synthesis.

Harmonic Series and Wave Shape

In an earlier tutorial we learned that the harmonic series is responsible for the character of a
sound. The presence and strength of each harmonic defines this character. But how does a
single string or vibrating body generate a series of related frequencies?

Density and tension being equal, short strings vibrate faster than long. A string that would
normally vibrate at 100 Hz divided in half (e.g. by pressing your finger on the finger board at
the half-way point) will vibrate twice as fast, or at 200 Hz. If you shorten it to one third its
original length, by pressing your finger higher, it will vibrate three times as fast or 300 Hz.
Shortening it to one fourth generates a frequency four times faster; 400 Hz.  Dividing a string
in such a way will produce harmonics. Harmonics are the foundation for scale degrees of
western music. The illustration below shows the pitches that correspond with each upper
harmonic. The lowest C is about 65 Hz, the next is 130, then 195, 260 (middle C), 325, 390,
455, 520, 585, 650, 715, 780, 845, 910, 975, 1040.

Most strings (and musical instrument bodies) vibrate at all those frequencies simultaneously.
While a string is vibrating at its full length it is also vibrating in halves. That half vibrating
motion is twice as fast. It is also vibrating in thirds, fourths, fifths, and so on. So a single
string vibrating at 65 Hz is also producing the frequencies 130, 195, etc.

Timbre is not only the presence, but also the amplitude of these harmonics. Each of the
harmonics is a sine wave. As a general rule the higher harmonics have a lower amplitude, but
the actual amplitude of each harmonic will differ with each timbre. The presence and
amplitudes of upper harmonics are the tonal fingerprint of any sound. A violin may have a
stronger third harmonic, weaker fourth, no fifth, weak sixth, while a trombone will have a
weak third, strong fourth, and so on. Using spectrographs one can see the unique fingerprint
of each timbre.

It is also important to understand that timbre (hence the shape of the wave and presence of
upper harmonics) changes in real time. Most musicians strive for, but never achieve perfect
tone quality. Yet it is this very failure that makes the sound natural. Synthesized sounds have
perfectly homogonous tones and we don't like that. For example, a sawtooth wave is
actually a series of sine waves tuned to the harmonic series with relatively lower amplitudes.
The same is true of other complex waves; square, triangle, even noise. All can be constructed
using individual sine waves. That is the theory of additive synthesis.

Additive Synthesis

Most synthesizers offer a variety of wave forms for building sounds but if the shape of the
wave is predefined you have no control (outside of filtering) over the individual harmonics.
But they are also incapable of additive synthesis, since they have only four or five sine
oscillators and maybe two or three envelope generators. But additive synthesis allows for
independent control over each wave’s parameters such as amplitude or envelope, and SC is a
virtual warehouse of synthesis VCOs. With only a few lines of code you can create hundreds
of partials with individual envelopes. But let's start with a dozen.

If we were to look at a sonogram of a sawtooth wave at 200 Hz, we would see that not only
does it have all harmonics, but they are very even and consistent. Each of these upper
harmonics can be thought of as sine waves with frequencies in multiples to the lowest,
or fundamental.

To reconstruct this sawtooth we need individual sine waves that are harmonic, or multiples of
the fundamental. Here is a crude version built on a fundamental of 400. Adding together 12
sine waves would normally distort, so they are all scaled down by 0.1.


Adding sines together
*/

(
{
(
	SinOsc.ar(400) + SinOsc.ar(800) + SinOsc.ar(1200) +
	SinOsc.ar(1600) + SinOsc.ar(2000) + SinOsc.ar(2400) +
	SinOsc.ar(2800) + SinOsc.ar(3200) + SinOsc.ar(3600) +
	SinOsc.ar(4000) + SinOsc.ar(4400) + SinOsc.ar(4800)
)*0.1
}.scope
)

// Harmonics adjusted

(
{
(
	SinOsc.ar(400, mul: 1) + SinOsc.ar(800, mul: 1/2) +
	SinOsc.ar(1200, mul: 1/3) + SinOsc.ar(1600, mul: 1/4) +
	SinOsc.ar(2000, mul: 1/5) + SinOsc.ar(2400, mul: 1/6) +
	SinOsc.ar(2800, mul: 1/7) + SinOsc.ar(3200, mul: 1/8) +
	SinOsc.ar(3600, mul: 1/9) + SinOsc.ar(4000, mul: 1/10) +
	SinOsc.ar(4400, mul: 1/11) + SinOsc.ar(4800, mul: 1/12)
)*0.1
}.scope
)
/*
This second version makes one more adjustment. The amplitude of each sine should decrease
in proportion to the partial number. The second partial should be 1⁄2 the volume of the first,
the third is 1/3rd, the fourth 1/4th, etc.

This next example uses a variable to calculate the upper harmonics and it uses an array to
spread the sine waves across different output busses. You probably don't have 12 outputs, but
that's ok, it is intended to be seen and not heard.  Also remember you can resize the scope window
to get a better look at each wave.

After resizing, change the style to "overlay" by pressing "s." This will overlay all the sine
waves so you can see them on one scope.
	Additive synthesis with a variable
*/

(
{
f = 100;
[
	SinOsc.ar(f*1, mul: 1), SinOsc.ar(f*2, mul: 1/2),
	SinOsc.ar(f*3, mul: 1/3), SinOsc.ar(f*4, mul: 1/4),
	SinOsc.ar(f*5, mul: 1/5), SinOsc.ar(f*6, mul: 1/6),
	SinOsc.ar(f*7, mul: 1/7), SinOsc.ar(f*8, mul: 1/8),
	SinOsc.ar(f*9, mul: 1/9), SinOsc.ar(f*10, mul: 1/10),
	SinOsc.ar(f*11, mul: 1/11), SinOsc.ar(f*12, mul: 1/12)
]
}.scope(12)
)
/*
This patch illustrates how harmonic waves interact. About a quarter of the way across this
graph you can see how all the sines are in synch and are pushing toward their peak. This is
what creates the sharp edge of a saw tooth wave. As the higher harmonics move downward
they begin to cancel out the energy of the lower waves. The aggregate of this process is a
gradually descending ramp of energy as more harmonics move into the negative phase of
their cycle, until the end of the pattern where you see they are all more or less in the negative
part of the graph. This is the bottom of the saw wave.

Changing the harmonics will change the character of the sound. Changing the amplitudes of
any single harmonic will subtly change the character. Try replacing any mul argument (a
higher one) with a MouseX.kr, isolating the amplitude of that single harmonic. Notice the
change. Below is the same patch, but each amplitude is being gradually controlled with an
LFNoise1. Notice that the fundamental pitch stays the same, while the tone quality changes.
Our brains add together all the sine waves and we hear it as a single pitch. Also note that this
is not filtering (covered below), but additive.

	Additive saw with modulation
*/

(
{
var speed = 14;
f = 300;
Mix.new([
	SinOsc.ar(f*1, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/1),
	SinOsc.ar(f*2, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/2),
	SinOsc.ar(f*3, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/3),
	SinOsc.ar(f*4, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/4),
	SinOsc.ar(f*5, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/5),
	SinOsc.ar(f*6, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/6),
	SinOsc.ar(f*7, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/7),
	SinOsc.ar(f*8, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/8),
	SinOsc.ar(f*9, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/9),
	SinOsc.ar(f*10, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/10),
	SinOsc.ar(f*11, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/11),
	SinOsc.ar(f*12, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/12)
])*0.5
}.scope(1)
)
 /*
Try changing the value for speed, which controls the frequency of the LFNoise. Then try
replacing all the LFNoise0 ugens with an LFNoise1 (use find and replace). Finally, replace f
= 100 with f = someOtherControl such as a sine wave, another LFNoise or  a mouse.

Next we are going to add an envelope. We could replace the last *0.5 with a single envelope
to control the amplitude of all the oscillators at once. And that's how most synthesizers with
limited modules do it. But since we are working with code we can assign an envelope to each
oscillator, making each harmonic independent, resulting in a more natural sound.

These examples are unnecessarily redundant (a sort of shotgun approach) to illustrate
additive methods clearly. Even so, with these few dozen lines we have already surpassed the
capacity of most commercial synthesizers. Granted, this exercise is a bit tedious, perhaps
giving you a glimpse of the pioneering efforts of early electronic composers working on
patch style synthesizers.


Additive saw with independent envelopes
*/

(
{
f = 100;
t = Impulse.kr(1/3);
Mix.new([
	SinOsc.ar(f*1, mul: EnvGen.kr(Env.perc(0, 1.4), t)/1),
	SinOsc.ar(f*2, mul: EnvGen.kr(Env.perc(0, 1.1), t)/2),
	SinOsc.ar(f*3, mul: EnvGen.kr(Env.perc(0, 2), t)/3),
	SinOsc.ar(f*4, mul: EnvGen.kr(Env.perc(0, 1), t)/4),
	SinOsc.ar(f*5, mul: EnvGen.kr(Env.perc(0, 1.8), t)/5),
	SinOsc.ar(f*6, mul: EnvGen.kr(Env.perc(0, 2.9), t)/6),
	SinOsc.ar(f*7, mul: EnvGen.kr(Env.perc(0, 4), t)/7),
	SinOsc.ar(f*8, mul: EnvGen.kr(Env.perc(0, 0.3), t)/8),
	SinOsc.ar(f*9, mul: EnvGen.kr(Env.perc(0, 1), t)/9),
	SinOsc.ar(f*10, mul: EnvGen.kr(Env.perc(0, 3.6), t)/10),
	SinOsc.ar(f*11, mul: EnvGen.kr(Env.perc(0, 2.3), t)/11),
	SinOsc.ar(f*12, mul: EnvGen.kr(Env.perc(0, 1.1), t)/12)
])*0.5
}.scope(1)
)

/*
Shortcuts

There is always an easier way to do things in SC. Limitations are often in the person writing
the code. We can use multi-channel expansion, covered in the previous chapter, to expand a
single line of code into an array of items. In the patch above the array (everything between
the two braces “[“ and “]”) is filled with oscillators that are written out fully. The Mix
combines them all into one channel.


	additive synthesis with array expansion
*/

Mix.new([SinOsc.ar(100), SinOsc.ar(200), SinOsc.ar(300)])

// The results are the same with this code

Mix.new(SinOsc.ar([100, 200, 300]))

/*
In the example below, the first midicps returns a single value. The second returns an array of
values. The next line shows a shortcut for writing an array that contains a series of numbers.
The last shows the patch above written using this technique. To the compiler, they are the
same. The advantage is economy in typing. It is also more concise and easier to read.

additive synthesis with array expansion & shortcuts
*/

midicps(60);

midicps([60, 62, 64, 65, 57, 69, 71]);

(1..12) // shortcut for [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

midicps((1..24)*60)

(1, 3..13) // means [1, 3, 5, 7, 9, 11, 13]

midicps((60, 63..72))

// additive synthesis with shortcuts

(
{
f = 100;
t = Impulse.kr(1/3);
Mix.new(
	SinOsc.ar(
		f*(1..12),
		mul: EnvGen.kr(
			Env.perc(0, 1),
			t,
			levelScale: 1/(1..12),
			timeScale: [1.4, 1.1, 2, 1, 1.8, 2.9, 4, 0.3, 1, 3.6, 2.3, 1.1]
		)
	)
)*0.5
}.scope(1)
)
/*
The timescale needs to be written out because it is not a logical series that can be expressed
with a shortcut. But if I don't really care what each value is, as long as it's between 1 and 3, I
could use rrand(1.0, 3.0).dup(12) to generate the array of values.

One situation where you might want to use a collection of unique values is in describing
chords or scales which have no simple geometric pattern, as shown below.

additive synthesis with array expansion
*/

(
{
t = Impulse.kr(1/3);
Mix.new(
	SinOsc.ar(
		[60, 64, 67, 71, 74, 78].midicps,
		mul: EnvGen.kr(
			Env.perc(0, 1),
			t,
			levelScale: 1/(1..6),
			timeScale: rrand(1.0, 3.0).dup
		)
	)
)*[0.3, 0.3]
}.scope(1)
)

(
{
Mix.new(
	Pan2.ar(
		SinOsc.ar(
			[60, 62, 63, 65, 67, 68, 71, 72].midicps,
			mul: LFNoise1.kr(rrand(0.1, 0.5).dup(8), 0.5, 0.5)
		),
		1.0.rand2.dup(8)
	)
)*0.2
}.scope(1)
)
/*
Filling an array

Another version of the patch below uses Array.fill to do all the typing, so to speak, for us.
Array.fill generates an array based on a function. Each item in the array is a result of the
function. The first example simply fills the array with random numbers. The second fills an
array with sine waves. The first argument for Array.fill is the number of items in the array
and the second is the function.

 Array.fill
*/

Array.fill(16, {100.rand})

Array.fill(16, {SinOsc.ar(100.rand)})

/*
When you give someone a task, such as cutting up apples, you often want to supply different
instructions for subsequent repetitions. For example, cut up ten apples but leave the first one
whole, cut the second one in half, the third in threes, the fourth in fourths, and so on. You can
see the pattern. Rather than tell the person each time the number of cuts I could just say count
each time and cut it into that many pieces. In order to do this, the system needs to know
which iteration it is on. It needs a counter.

The Array object does have a counter to keep track of the number of repetitions and that
number is passed to the function by way of an argument. You see this new syntax within the
function: arg counter. You can name this argument anything you like. It's like a variable, but
it comes from outside the function. In this case I call it counter. Run each of the lines below
and check the results in the post window. The last two examples show an alternate
syntax: |counter| same as arg counter.

Array.fill with arg
*/

//fill an array with the number of this iteration
Array.fill(16, {arg counter; counter})

//fill an array with random numbers
Array.fill(16, {arg counter; [counter, rrand(20, 100)]})

//fill an array with multiples of counter with shorthand
Array.fill(16, { |counter| counter*3})

//fill an array with SinOsc objects, each with a freq of the counter*100
Array.fill(16, { |counter| SinOsc.ar(counter*100)})

/*
To build a harmonic series you want to multiply some fundamental by 1, then 2, 3, 4, etc.
The counter can be used to calculate the freq of each SinOsc and the levelScale of each
EnvGen. The counter begins at 0, not 1, and I don't want to start with freq*0, so I use the
variable partial to increase it by 1. The code below generates 16 upper partials, each
proportionally softer, with a random decay between 0.1 and 2.1. The fund*partial ensures
they are all harmonic. The 1/partial is the levelScale for the envelope. The first will be 1/1,
he next 1/2, 1/3, 1/4, etc. Array.fill returns an array of SinOsc ugens and Mix.ar mixes them
all down to one channel.

Additive saw wave, separate decays
*/

(
{
var gate, fund;
gate = Impulse.kr(1/3);
fund = MouseX.kr(50, 1000);
Mix.new(
	Array.fill(16,
	{arg counter;
	var partial;
	partial = counter + 1;
	SinOsc.ar(fund*partial) *
	EnvGen.kr(Env.adsr(0, 0, 1.0, TRand.kr(0.2, 2.0, gate)),
		gate, 1/partial)
	})
	)*0.2 //overall volume
}.scope(1)
)

/*
I began this section praising SC's capacity for complexity and richness. The patch above isn't
that astonishing, but you should recognize the more natural sound in the different decay rates
for each partial. Compare it with this patch, which uses only one envelope for all partials.

Additive saw wave, same decays
*/

(
{
var gate, fund, env;
gate = MouseButton.kr(0, 1, 0);
fund = MouseX.kr(50, 1000);
env = Env.adsr(0, 0, 1.0, 2.0);
Mix.new(
	Array.fill(16,
	{arg counter;
	var partial;
	partial = counter + 1;
	SinOsc.ar(fund*partial) *
	EnvGen.kr(env, gate, 1/partial)
	})
	)*0.2 //overall volume
}.scope(1)
)

/*
When working with code based synthesis (as opposed to graphics) it is easy to duplicate a
single simple idea to achieve complex sounds quickly. This is especially evident with
additive synthesis. Take for example this simple patch, where the amplitude of an oscillator
is being controlled by another sine wave.


Single sine with control
*/

{SinOsc.ar(400, mul: SinOsc.ar(1/3, mul: 0.5, add: 0.5))}.play

/*
We can use this single model to build a much more complex sound by adding together sine
waves as harmonics. Mix.fill combines the fill logic used with Array.fill and the Mix used
previously. It generates an array of ugens and mixes them down. It also has a counter
argument that can be used to calculate upper harmonics.


Gaggle of sines
*/

(
{
	var harmonics = 16, fund = 50;
	Mix.fill(harmonics,
			{ arg count;
				Pan2.ar(
					FSinOsc.ar(
						fund * (count + 1), // calculates each harmonic
						mul: FSinOsc.kr(rrand(1/3, 1/6), mul: 0.5, add: 0.5 )),
					1.0.rand2)
			}
	) / (2*harmonics)
}.play;
)

/*
Inharmonic spectra

Each of the sine waves in the examples above is a multiple (f*1, f*2, f*3, f*4, etc.) of the
fundamental. This is a harmonic spectrum. Most pitched instruments have harmonic spectra.
Non-pitched instruments such as gongs, bells, and cymbals tend toward inharmonic spectra,
or a set of frequencies that are not multiples of the fundamental. To generate an inharmonic
spectrum you need to enter unrelated values for each sine wave, for example, 72, 135, 173,
239, 267, 306, 355, 473, 512, 572, and 626.

In the examples above the amplitude of each upper harmonic was calculated in relation to it's
position; higher harmonics were softer. But in enharmonic spectra the amplitudes don't have a pattern.
For example, 0.25, 0.11, 0.12, 0.04, 0.1, 0.15, 0.05, 0.01, 0.03, 0.02, and 0.12.

Additive synthesis can be used to generate pure wave forms, such as sawtooth, square, or
triangle, but these are available on commercial synthesizers. It is true, you have more control
over the upper partials, but at least these other wave forms do exist. But wave forms with
enharmonic spectra do not. Commercial synthesizers go straight from perfect wave forms to
perfect noise. Nothing in between.

Here is a patch that adds together these frequencies and amplitudes.


Inharmonic spectrum
*/
(
{Mix.new(
	SinOsc.ar(
		[72, 135, 173, 239, 267, 306, 355, 473, 512, 572, 626],
		0, //phase
		[0.25, 0.11, 0.12, 0.04, 0.1, 0.15, 0.05, 0.01, 0.03, 0.02, 0.12]
	))}.scope(1)
)
/*
Random Numbers, Perception

I used a deck of cards to come up with the frequencies in the examples above. We say they
are "random" because there is no apparent pattern. But randomness is a matter of context and
perception. A single number with no context cannot really be random.
As an illustration: Can, you, predict, the, next, number, in, this, series?
116, 966, 7733428, 843, 6398, 686237, 46, 8447, _____

Seem random? It is not (note there are no 5s or 0s). When you get the trick you can predict
the next number and maybe the next three or four. When you see the pattern the random
quality evaporates, even though the series or process hasn’t changed. Then what has
changed? Your perception. A good lesson to apply in other areas of music appreciation (and
life).

When I shuffle a deck of cards they are "randomized" so that I can't predict what the
sequence of cards would be. But if I knew the order of the cards before the shuffle, and I
used a precise formula (e.g. exactly one from each pile in turn), or kept close track of the
order in which the cards fall during shuffling, I would then be able to predict the order. If that
were the case, the deck would not be randomized. The only difference is my perception. So
what random really means is mixed up to the point where, or complex enough that, a
particular human can't predict the outcome.

To generate random sequences composers have resorted to a sort of number shuffling using a
formula. The computer "knows" the sequence, because it is a formula,
but the formula is so complex that we don't recognize the pattern. Computers use a random
number generator, which is a (very long) series of numbers created each time the program is
run. The odd thing is that the order never changes because the same formula is used each
time; the set of numbers rest in the computer's memory intact. So to the computer it is not
random at all. It's like a deck of cards that has been shuffled once, but is never shuffled again.
When you run a program that generates supposedly random events (such as a dice or card
game), the computer looks for values from this sequence of numbers. The problem is it
always starts at the beginning, so you always get the same values at first, like using the same
deck of cards from the top of the deck without cutting or reshuffling. The order will seem
randomized the first few times through the series, but will never change. After two or three
repetitions we will remember the pattern and it won't be random anymore. Part of random, to
us, is different numbers each time.

So how do you get it to do different numbers? You cut the deck. To cut the deck of a random
number generator you start at a different point in the series. This is called a random seed.
You give the computer a number as a seed which is used to count into the random number
sequence. The computer then starts using numbers from that point.

There is one more problem. If you know the seed, then the resulting sequence of numbers is
still not really random to you. You need to choose a random seed. I mean, you need to
choose a random seed randomly. I mean, that random seed has to be random (perplexing?).
The solution to this problem is to use the internal clock of a CPU, which is just a series of
numbers rapidly flying by. If each number on the clock were matched to a number in the
random sequence, then in a sense you are zipping through the random sequence (like riffling
the shuffled deck). Grabbing a number from the clock and using it as a seed is like sticking
your finger in the riffling deck: you get a random position at that moment. It seems a little
convoluted, but that's how it was (and is) done.

SC does a random seed automatically behind the scenes. Each time you run a line like
10.rand SC first reads the number on its internal clock to use as a seed. It then moves into the
random number generator sequence and starts its sequence of choices from that point. It is
random to us because we can't predict what number the clock gave or the order of the
numbers at that point.

That’s how you get pseudo-random choices. But there are also situations where you want
“random” choices, but same “random” choices. In this case you would use the same seed
over and over to reproduce the same series of events. (For example, many computer card
games allow you to replay the previous hand. This is how it's done.) A given random seed is
useful when you are debugging a crash and want to reproduce the same error every time.
Also you might find a particular variation of random events that you like and will want to
reproduce it exactly.

First I'll demonstrate some random choices and then some random choices using a seed.
There are a number of random functions in SC. The message rand sent to any number will
return a random choice between 0 and that number. 55.rand will return an integer (e.g. 1, 2,
3) between 0 and 55 (not including 55). 55.0.rand will return a floating point number (e.g.
3.3452, 1.2354) between 0.0 and 55.0. Try both lines several times each to see how random
numbers are chosen.


rand
*/

10.rand;

10.0.rand;

/*
Running the lines several times over and over is a bit cumbersome, so below is a method of
testing random choices using the dup message, which fills an array with duplicate returns of
the function.

Test a random array
*/

{100.rand}.dup(20)

/*

Error from not using a function
*/

(100.rand).dup(20)

/*
It picks a random number, but it uses that same number each time. The first example uses a
random number choice enclosed in a function. A function means "run this line of code" while
100.rand on its own means pick a random number. {100.rand} means pick a random number
each time, 100.rand means pick a random number and use it each time.

Below is the same example using a seed on the client side (the language an programming
side). Run the first line several times to see how it fills an array with random values. Then
run the second line several times. Since you are seeding the random generator each time you
will get the same numbers in the array. Try changing the seed to something other than 5.
You'll get a new series, but the same series each time. (Not very "random" after four runs.)

Client random seed
*/

{100.rand}.dup(20);

thisThread.randSeed = 5; {100.rand}.dup(20);

/*
This does not, however, affect the server, which plays the sounds once you design a patch.
To seed a random process on the server use RandSeed. This ugen can be triggered, so you
can reset the seed over and over. The first argument is the trigger, the second the seed. Run
the first and second examples several times. Let the third one run. It will reset every 5
seconds.

Server random seed
*/

// different every time
{SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)}.play

// same every time
(
{
RandSeed.kr(1, 1956);
SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)
}.play
)

// resets every 5 seconds
(
{
RandSeed.kr(Impulse.kr(1/5), 1956);
SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)
}.play
)
/*
Finally, what if you want the seed to be chosen in the regular way (using the clock), but you
want to know what it is so you can reproduce that series later for debugging or because you
liked that version? Here's how.


Post clock seed
*/

thisThread.randSeed = Date.seed.postln; {100.rand}.dup(20);

(
{
RandSeed.kr(Impulse.kr(1/5), Date.seed.postln);
SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)
}.play
)
/*
The seed is taken from the clock and posted to the data window. If you want to reproduce
that version, replace Date.seed.postln with the number posted to the window.

In conclusion, one could argue that a generative composition is not really random, since it
can be duplicated with the same seed. It seems random because we haven’t heard that series
of numbers before. But each seed (billons of them), represents a specific repeatable version.
So instead of a random process, it can be thought of as a billion possible variations, each
identified by that seed. The code you write then is the DNA for billions of variations, of
which one is chosen at each performance, and can be identified and repeated with the seed.

Here are some other ways to generate random numbers:
*/

rand(30)  //returns a random value between 0 and 29

rand2(20)  //returns a random value between -20 and 20

rrand(20, 100) //returns a random value between 20 and 100

/*

Bells

Upper harmonic structure is a “timbre” fingerprint. It helps us distinguish what the sound is
(violin, flute, voice), and even subtle variations between instances of the same sound (your
mom with a cold). Even though a collection of frequencies are inharmonic, a "random"
collection, we still can easily distinguish it from any other "random" set of frequencies as
illustrated with the bell patches below.

The code below generates a set of bell like sounds, each with it's own pseudo-random
spectrum. Try reading the code from the center out. The innermost SinOsc has a random
frequency between 50 and 4000. It is multiplied by an envelope with a decay between 0.2
and 3.0 and a volume between 0 and 1. This code is inside a function with the dup message
with 12 as an argument. The dup message creates an array of SinOsc ugens with differing
frequencies and envelopes. Since the trigger is created outside the function, all the Ugens
share this single trigger. The attacks will be the same and it will appear as a single sound.
Those 12 sine waves, or inharmonic frequencies, are mixed down using Mix.ar and panned
with Pan2. Try stopping playback and running the first example again. Repeat this four or
five times. Can you tell that some frequencies have longer or shorter decay rates?

With each execution the computer chooses a different set of random numbers from the
random number generator to create each bell. Could you enter a line of code that would use a
random seed and produce the same bell collection twice in a row?

Finally, run the example four or five times without stopping the previous bell, so that 5 or 6
bells are running at once. Notice that even though each single bell is actually a collection of
supposedly independent and randomly chosen sine waves our brains meld them into a single
recognizable sound. Also, even though each collection is random, we distinguish it as a
separate entity, and we can keep track and recognize a group of them.

I can't help raising this question: When is the "random" collection no longer random? When
you hear it the second time?



random frequencies (Pan2, Mix, EnvGen, Env, fill)
*/

(  // Let it run for a while, the strikes are random
{
var trigger, partials = 12;
trigger = Dust.kr(3/7);
Pan2.ar(
	Mix.ar(
		{
		SinOsc.ar(rrand(50.0, 4000)) *
		EnvGen.kr(
			Env.perc(0, rrand(0.2, 3.0)),
			trigger,
			1.0.rand
			)
		}.dup(partials)
	)/partials,
	1.0.rand2
)
}.play
)

/*
 CPU Usage

SC is not an unlimited supply of synthesis components. We are limited by processing
power. Additive synthesis is costly, and the cpu information in the server window is now important.
It shows average and peak cpu and number of Ugens. Run the
patches above several times (without stopping the previous sound) or increase the number of
partials to see what happens when you max out the cpu load.

On my laptop I can get it up to over 10161 ugens and be at only 30%. That's a far cry from the
two dozen modules on vintage gear.

Go back to the single bell patch and increase the number of partials. Watch the CPU increase,
but also notice how the sound changes as you add partials. What is the result of 200+
inharmonic partials?

As the number of random partials increase the sound becomes more and more unfocused
until it approaches noise. That is covered in the next chapter.

Just a footnote about the last practice examples below, diverging, converging, and decaying
gongs: I like these examples because they sound so cool, and they are so different from
anything in real life, but also because they were artificially conceived.
*/

(
{
var trigger, fund;
trigger = Dust.kr(3/7);
fund = rrand(100, 400);
Mix.ar(
	Array.fill(16,
	{arg counter;
	var partial;
	partial = counter + 1;
	Pan2.ar(
		SinOsc.ar(fund*partial) *
		EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0),
			trigger, 1/partial
		) * max(0, LFNoise1.kr(rrand(5.0, 12.0))), 1.0.rand2)
	})
	)*0.5 //overall volume
}.play
)

//Several of the above mixed down

(
{
var trigger, fund, flashInst;
flashInst = Array.fill(5,
{
	trigger = Dust.kr(3/7);
	fund = rrand(100, 400);
	Pan2.ar(
		Mix.ar(
			Array.fill(16,
			{arg counter;
			var partial;
			partial = counter + 1;
				SinOsc.ar(fund*partial) *
				EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0),
					trigger, 1/partial
				) * max(0, LFNoise1.kr(rrand(5.0, 12.0)))
			})
			)*0.2,
	 1.0.rand2)
});
Mix.ar(flashInst)*0.6
}.play
)

// Gaggle of sines varations

(
{
	var harmonics = 16, fund = 50, speeds;
	speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/5;
	Mix.fill(harmonics,
			{ arg count;
				Pan2.ar(
					FSinOsc.ar(
						fund * (count + 1),
						mul: max(0, FSinOsc.kr(speeds.wrapAt(count)))),
					1.0.rand2)
			}
	) / (2*harmonics)
}.play;
)

// Use mouse to change fundamental

(
{
	var harmonics = 16, fund, speeds;
	speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/20;
	fund = (MouseX.kr(0, 36).round(7) + 24).midicps;
	Mix.fill(harmonics,
			{ arg count;
				Pan2.ar(
					FSinOsc.ar(
						fund * (count + 1),
						mul: max(0, FSinOsc.kr(speeds.choose))),
					1.0.rand2)
			}
	) / (2*harmonics)
}.play;
)



(
{
	var harmonics = 16, fund;
	fund = (MouseX.kr(0, 36).round(7) + 24).midicps;
	Mix.fill(harmonics,
			{ arg count;
				Pan2.ar(
					FSinOsc.ar(
						fund * (count + 1),
						mul: max(0, FSinOsc.kr(rrand(1, 1/3), mul: 20).softclip)),
					1.0.rand2)
			}
	) / (2*harmonics)
}.play;
)

(
{
	var harmonics = 16;
	Mix.fill(harmonics,
			{ arg count;
				Pan2.ar(
					FSinOsc.ar(
						exprand(100, 2000),
						mul: max(0, FSinOsc.kr(rrand(1/3, 1/6))*rrand(0.1, 0.9))),
					1.0.rand2)
			}
	) / (2*harmonics)
}.play;
)



// Dissipating and converging gongs illustrates how a patch can be built
// from duplicating one idea; classic additive synthesis. It also shows
// how additive synthesis can be used to control each harmonic.
// Listen in stereo to hear the harmonics diverge.

(

{
var dur = 6, base, aenv, fenv, out, trig;
base = Rand(40, 100);
trig = SinOsc.ar(1/10);
out = Mix.fill(15,{
	var thisDur;
	thisDur = dur * rrand(0.5, 1.0);
	aenv = EnvGen.kr(Env.perc(0, thisDur), trig);
	fenv = EnvGen.kr(Env.new([0, 0, 1, 0], [0.25*thisDur, 0.75*thisDur, 0]), trig);
	Pan2.ar(SinOsc.ar( Rand(base, base * 12) *
		LFNoise1.kr(10, mul: 0.02 * fenv, add: 1), // freq
		mul: aenv // amp
	), ([1, -1].choose) * fenv)
}) * 0.05;
out
}.play(s);


{
var dur = 6, base, aenv, fenv, out, trig, detune;
base = Rand(40, 60);
detune = 0.1; // increase this number to detune the second bell
trig = SinOsc.ar(1/10, pi);
out = Mix.fill(15,
{ arg count;
	var thisDur;
	thisDur = dur * rrand(0.5, 1.0);
	aenv = EnvGen.kr(Env.perc(0, thisDur), trig);
	fenv = EnvGen.kr(Env.new([1, 1, 0, 1], [0.05*thisDur, 0.95*thisDur, 0]), trig);
	Pan2.ar(SinOsc.ar( base*(count+1+ detune.rand) *
		LFNoise1.kr(10, mul: 0.02 * fenv, add: 1), // freq
		mul: aenv // amp
	), ([1, -1].choose) * fenv)
}) * 0.05;
out
}.play(s);
)

// Decaying bell

(
{
var aenv, fenv, out, trig, dur, base;
dur = rrand(1.0, 6.0);
base = exprand(100, 1000);
trig = Impulse.kr(1/6);
out = Mix.ar(
	Array.fill(15,{
		arg count;
		var thisDur;
		thisDur = dur * rrand(0.5, 1.0);
		aenv = EnvGen.kr(
			Env.new([0, 1, 0.4, 1, 0], [0, 0.5, 0.5, 0]), trig,
			timeScale: thisDur);
		fenv = EnvGen.kr(
			Env.new([0, 0, 0.5, 0.5, 0], [0.25, 0.5, 0.25, 0]),
				trig, timeScale: thisDur);
		Pan2.ar(SinOsc.ar( Rand(base, base * 12) *
			LFNoise1.kr(10, mul: 0.1 * fenv, add: 1), // freq
			mul: aenv // amp
		), ([1, -1].choose) * fenv)
	})
) * EnvGen.kr(Env.linen(0, dur, 0), Impulse.kr(6), timeScale: dur,
		levelScale: 0.05, doneAction: 2);
out*0.3;
}.play;
)


