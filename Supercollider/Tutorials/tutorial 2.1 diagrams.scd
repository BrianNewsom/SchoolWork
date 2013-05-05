s = Server.localhost
/*

Musc 5121

Tutorial 2 - More Intro and Flow Charts

The following patches will explore some of the introductory programming aspects of SC 3. This will include using
variables and UGens in the argument list and two channel expansion. (Using multiple channels, or busses, is a
complex issue in SC and will be discussed later.) These concepts will be covered again later, so if you are not
comfortable just yet, don't worry, be happy.

First, let's look a simple patch. Here we have a sine wave oscilator at a frequency of 400, a phase of 0, a multiplication
of the signal of 0.3 and an add of 0. The important parts of this argument list are the freq and mul slots.

*/
//basic sine wave

(
{SinOsc.ar(400, 0, 0.3, 0)}.play
)

/*

If we want to have a stereo signal, we need to create an array of two frequencies in the first argument.

*/

//add another channel
(
{SinOsc.ar([400, 600], 0, 0.3, 0)}.play
)

/*

We can declare variables and insert them into the argument list. This means that you can define a word or letter,
not a number, to represent a value. In the example below, the word freqs is "declared" as a variable and then defined.

The process is this:

Write the word "var" and then the variable name, such as beerDrink. Then define what that variable is:

beerDrink = 349.26

In the first example the freqency argument is replaced by a variable. In the second axample variables are used to
define all the arguments.

*/

//make args variables
(
var freqs;
freqs = [400, 700];
{SinOsc.ar(freqs, 0, 0.3, 0)}.play
)

(
var freqs, phz, vol, ad;//key word assignment will be discussed later
freqs = [400, 800];
phz = 0;
vol = 0.5;
ad = 0;

{SinOsc.ar(freqs, phz, vol, ad)}.play
)


/*

You can also insert a UGen as an argument. In the examples below, the UGen XLine is used as an argument for mul
and then freq. Look at the help files to understand the parameters of this UGen.

*/

//use a Ugen as argument input

(
var freqs;
freqs = [400, 700];

{SinOsc.ar(freqs, 0, XLine.kr(0.01, 0.8, 10), 0)}.play
)

(
{SinOsc.ar(XLine.kr([300,600], [800, 850], 6), 0, 0.3, 0)}.play
)

/*

You can define a UGen as a variable, but make sure it is inside the function, that is, inside the braces.

*/

//doesn't work - var needs to be part of function
(
var freqs;
freqs = XLine.kr([300,600], [800, 850], 800, 6);

{SinOsc.ar(freqs, 0, 0.3, 0)}.play
)


(
{var freqs;
freqs = XLine.kr([300,600], [800, 850], 6);

SinOsc.ar(freqs, 0, 0.3, 0)}.play
)

/*

Following are some examples using LFNoise0, the first two are plugged into the argument list, and then, as variables.
The fourth example uses two UGens in the variable. We'll be looking at the Mouse UGens later.

*/

{SinOsc.ar(LFNoise0.ar(10, 400, 800), 0, 0.3)}.play

{SinOsc.ar([LFNoise0.ar(10, 400, 800), LFNoise0.ar(5, 300, 500)], 0, 0.3)}.play

(
{var noise1, noise2, noise0;
noise1 = LFNoise0.ar(10, 400, 800);
noise2 = LFNoise0.ar(5, 50, 90);

SinOsc.ar([noise1, noise2], 0, 0.4, 0)}.play
)

(
{var noise1, noise2, noise0;// declare the variable
noise1 = LFNoise0.ar(MouseX.kr(10, 50), 400, 800);// define first var
noise2 = LFNoise0.ar(MouseY.kr(1, 10), 50, 90);// define second var

SinOsc.ar([noise1, noise2], 0, 0.4, 0)}.play //the synth
)


/*

The next example uses the UGen Mix which we will cover in more detail later. As you begin to
 build more complex patches and you want to try out different parameters, using variables makes
 it easier to change those parameters as you won't have to hunt through all the UGen argument lists.

*/

(
{
	// mixing sine oscillators in parallel
	var n = 16; // number of structures to make
	// mix together  parallel structures
	Mix.fill(n,
			// this function creates an oscillator at a random frequency
			{ FSinOsc.ar(200 + 1000.0.rand) }
	) / (2*n)			// scale amplitude
}.scope(1);
)

//stereo version

(
{
	// mixing sine oscillators in parallel
	var n = 16; // number of structures to make
	// mix together  parallel structures
	Mix.fill(n,
			// this function creates an oscillator at a random frequency
			{ FSinOsc.ar([200 + 1000.0.rand, 100 + 500.0.rand]) }
	) / (2*n)			// scale amplitude
}.scope(2);
)

/*
Note that all the letters, a to z, are automatically reserved as variables. You do not need to
declare them as such, just write f = 440. In the following example, the output of a short patch
is split into two equal channels using Out.ar. The Out object will create up to 128 audio output
busses. (Check out Pan2 for two channel panning.)
*/

(
{x = SinOsc.ar(520, 0, 0.5, 0);
	Out.ar([0, 1], x)
}.scope(2)
)

/*
Making Flow Charts

One of the tools that helped me early on in my struggles with SC, was to make diagrams of the signal flow of
a patch. The first step is to open the help files for each of the oblects and then figiure out where those
nested objects "plug" into the appropriate argument of the object that is higher up in the order of execution.

Flow chart examples: the first patch is "Bubbles" and is shown on the handout. The second patch will be done in class.

In the first example, add comments to each line describing that line of code. Any text followed by double forward slahes
will not be evaluated.
*/

// Bubbles


(
{
 CombN.ar(
   SinOsc.ar(
     LFNoise1.kr(
         4,
        24,
           LFSaw.kr(
                [8,7.23],
                 0,
                 3,
                 80
                    )
                  ).midicps,
                 0,
                 0.04
            ),
        0.2,
        0.2,
        4
       )
}.play
)












// LFO modulation of Pulse waves and resonant filters
(
	{CombL.ar(
		RLPF.ar(
			LFPulse.ar(
				FSinOsc.kr(0.05,0,80,160),
					0,0.4,0.05),
		   FSinOsc.kr([0.6,0.7],0,3600,4000),
		   	0.2),
		0.3, [0.2,0.25], 2)
	}.play
)

