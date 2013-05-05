s = Server.local.makeWindow.boot;

/*
MUSC 5121 Tutorial 3
Modifying and Controlling the Elements of Sound
Writing Audio to a File

Frequency, Amplitude, and Timbre
The following examples will demonstrate how one can control the elements of sound including frequency, amplitude, and timbre.
Start your server (make sure the internal srever is running) and execute the code below. The SinOsc.ar generates a sine wave at 500 Hz. The scope message reads the results of that function and plays it. It also shows a graphic representation of the sound in a new window. The peaks represent the speaker moving out and the valleys are when the speaker is moving in. The graph you see in the scope is an actual representation of how the speakers move. As the speakers move they compress and rarify the air, creating sound waves.
Try changing the add(offset) argument: 0, 0.5, -0.5 - more on add later...
*/

(
{SinOsc.ar([500, 500], 0, 0.5, 0)}.scope(2)
)


(
{SinOsc.ar([500, MouseX.kr(500,1000)], 0, 0.5, MouseX.kr(-0.5 , 0.5))}.scope(2)
)

/*
The first argument for SinOsc.ar is freq, set to [500, 500], an array with two values for left
and right channels. Try changing the values of one or both of those numbers. Look for the
relationship between what you see in the scope and what you hear in your headphones.
The mul argument will chage the volume of the wave, making the wave shape wider or narrower,
depending on the number you assign. Remember, use value from 0 to 1.

Look at the help file again for SinOsc. It shows that the arguments are: freq, phase, mul, add.
We used the freq argument to change frequency. It's important to understand that the SinOsc
is generating a stream of numbers which represent the sound wave. The numbers run
smoothly from 0 up to 1, then down to -1, and back to 0 over and over. A sampling of these
numbers might be [0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1.0, .9, .8, .7, .6, .5, .4, .3, .2, .1, 0, -.1, -.2,
-.3, ] and so on. The mul argument scales or multiplies these numbers making the overall
wave move higher and lower. If we change this value to, say, .5, then all of those numbers
will be multiplied by .5, or reduced by 1⁄2. So [0, .1, .2, .3, .4, ] etc. will become [0, .05, .1,
.15, .2, ] and so on up to .5, then back down. We will start with 1, which is the maximum
amplitude the system can manage.

If you exceed a value of 1 you will create distortion. The are, however, better ways to create distortion.
*/

//remove your headphones before plaing this example

{SinOsc.ar(500, 0, 20.0)}.scope(1)

/*
Periods, Shpes and Timbre

The following example demonstrates a sound source that geneates non-pitched sound.
The reason we do not hear a pitch is that there is no pattern (at least that we can perceive) to
the sound. The sine wave moved smoothly from 0, to 1, 0, -1, 0 then repeated that motion. A
sound wave (of any shape or contour) that has any type of repeated pattern is periodic.
Periodic waves are heard as a pitch. Each revolution through the pattern is called a period,
wave or cycle. A sound with no pattern is aperiodic and will not be heard as pitched. There is
a continuous scale between periodic and aperiodic, so a wave can be more or less periodic.
The clearer the periods, the clearer the pitch.

*/

{WhiteNoise.ar(0.7)}.scope(1)

{PinkNoise.ar(0.7)}.scope(1)

{BrownNoise.ar(0.7)}.scope(1)

{LFNoise0.ar(0.7)}.scope(1)

{Dust.ar(0.7)}.scope(1)

BlackNoise - http://www.youtube.com/watch?v=MZTSLN_OW-c

/*
Frequency is pitch, size of the wave or amplitude is volume, and wave shape is timbre. We
will discuss timbre later, but for now understand that different shapes of waves generate
different timbres. In general, waves with sharp changes in direction are brighter timbres.
Below are some examples of other forms. Use the mouse (top to bottom) to hear a different
wave. They are, in order, a sine wave, a saw wave, a pulse, triangle, low frequency noise,
"dust", pink noise, and white noise. You can resize the scope.

*/

(
{Out.ar(0, In.ar(MouseY.kr(3, 12).div(1), 1)*0.8)}.scope;
{Out.ar(4, [SinOsc.ar, Saw.ar, Pulse.ar,
	LFTri.ar, LFNoise0.ar, Dust.ar(100),
	PinkNoise.ar, WhiteNoise.ar])}.scope(12)
)

/*
While you can clearly hear the difference between the first four, the noise examples are less
distinct. The difference in wave types can change how they sound, but later we will use these
as control sources, that is, to shape some other parameter. In these cases it is important to
understand the shape of each wave, since the parameter being controlled (e.g. frequency)
inherits that shape. The shape of the sine, triangle, saw, and pulse waves are clear. The
LFNoise0 and LFNoise1 are random (aperiodic) waves. LFNoise0 generates discrete step
values. LFNoise1 generates interpolated, or ramped values.


Phase

In most cases the quality of sound is not affected by changes in phase, but it's an important
concept in understanding how timbre, phase cancellation, and constructive or destructive
interference work. Here is the line of code we started with.
*/

{SinOsc.ar(500, 0, 0.7)}.scope


/*
The second argument (0) is phase. Try changing
this argument to the values 0.785, then 1.57, then 2.355 and finally 3.14. Why are these
numbers significant? They are fractions (1/4, 1/3, 3/4) of pi. The plots of the wave will begin
at the corresponding point of its cycle. 3.14 (pi) is halfway through the cycle, 2*pi is the full
cycle. SC3 understands pi, so it is used in the code below to illustrate progressive phases.
Phase is also often expressed as degrees. 0 is 0 ̊, 0.5pi is 90 ̊, pi is 180 ̊, 1.5pi is 270 ̊, and 2pi
would be 360 ̊, or full cycle.

The first bit of code adds two signals of the same frequency together but they are 180 degrees in opposition
*/
(
{SinOsc.ar(400, 0, 0.5, 0)+
SinOsc.ar(400, pi, 0.5, 0)}.scope
)

(
{SinOsc.ar(400, 0, 0.5, 0)+
SinOsc.ar(400, MouseX.kr(0, pi), 0.5, 0)}.scope
)


//The next example shows an array of different phases

{SinOsc.ar(400, [0, 0.5pi, pi, 1.5pi, 2pi])}.scope



/*

Phase does affect two aspects of synthesis: the way two waves interact (when they are
different phases) and the way a control wave interacts with its target, as we will see later.
To illustrate the second way phase affects sound I'm going to jump ahead to an example that
uses the sine wave as a control (covered in depth later). The second SinOsc in the next
example is controlling the pitch (rounded and converted from MIDI) of the first SinOsc. In
simple terms, the shape of the sine wave is being applied to a virtual piano keyboard from F4
to G5; sweeping across the keys in the same way the wave moves up and down. But as you
will hear, the first example doesn't begin with F4, but rather C4, the middle pitch. That's
because the sine wave begins at 0, then moves up to 1, down to -1, and so on. When the
phase argument is changed to 0.5pi (or 1⁄4 through its phase), it will begin at its peak, and
therefore the top of the F4, G5 range. If set to 1pi, it will begin half way through the cycle, at
0, but continue moving down. 1.5 pi will begin at its valley. Run the first line for plots of all
four examples, then each example and listen carefully to where the pitches begin.
*/

// Phase you can hear (as control)
// all phases: 0, .5, 1, 1.5

{SinOsc.ar(400, [0, 0.5pi, pi, 1.5pi])}.scope;

// 0 phase
{SinOsc.ar(SinOsc.ar(0.3, 0, 7, 72).round(1).midicps, 0, 0.7)}.scope

// 0.5pi (1/4) phase
{SinOsc.ar(SinOsc.ar(0.3, 0.5pi, 7, 72).round(1).midicps, 0, 0.7)}.scope

// 1pi (1/2) phase
{SinOsc.ar(SinOsc.ar(0.3, 1pi, 7, 72).round(1).midicps, 0, 0.7)}.scope

// 1.5pi (3/4) phase
{SinOsc.ar(SinOsc.ar(0.3, 1.5pi, 7, 72).round(1).midicps, 0, 0.7)}.scope



/*
Recording (Writing to a File)

There are a number of approaches that one can take when composing electroacoustic music. There is real-time DSP and synthesis where the code you write wiil play a complete piece. There is also the classic "tape music" approach which uses pre-made sounds and arranges them in to a DAW (Digital Audio Workstation) like ProTools, Digital Performer, Logic, Audacity, etc. To use SuperCollider sounds we will need to be able to record our patches as a sound file before we can import them into an editing program.

If you want to use the record feature on the server windows, first click on the
->default button on the server you wish to use. Then, click on the prepare rec button, start a patch and click on record. Click stop when you are done.

You will find your recording in the SuperCollider Recordings folder, found in the Music partition named something like this:
SC_080129_092422.aiff

When you record this way your files will be recorded with default values and you will
probably want to rename your recording.


If you need to use values other than the defaults you can use command lines so you can set the bit depth, give it a name and set the number of channels.The following are the command lines to setting the defaults, number of channels, file name, and starting and stopping the recording.

Record bit depth, channels, filename
*/

s.recSampleFormat = "int16";
s.recChannels = 1;

/*
This creates a file in the SUperCollider Recordings folder.
*/

s.prepareForRecord;


/*
 Before running these lines go back and run a previous example
 so you have something to record.
 */

s.record
s.stopRecording
s.play;




s.recSampleFormat = "int16";
s.recChannels = 1;// chnage to 2 for stereo
s.prepareForRecord
s.record
s.stopRecording

/*
Using code to record to disk can be clunky, so the fast and
safe way is to use the server windows to record your sound. On
the default server, click on prepare rec, the rec, then stop when you are finished. Your recording will be saved in the Music partition of the hard drive in a folder named SuperCollider Recordings.

If you use the Server window to record your sounds, you will need to convert your sound file into a format that your sequencer can read. To do
this open your sound file in QuickTime 7 and export as an aiff file. You can also open the file in Audacity and export the file from there.

Play time! (CombN, SinOsc, abs, LFNoise1, LFSaw, array) - Play around with this,
change values, record to a file...
*/


(
   // Double click the parenthesis above to quickly select
	// the entire patch
	// Or use com-shift-b
{
i = SinOsc.ar( //Sine wave osc
		abs( //This protects against negative values
			LFNoise1.kr(
				0.5, //frequency overall wandering
				2000, //range of overall wandering
				LFSaw.kr(
					[1.5, 1.91], //left and right channel
							//speed of the individual sweeps
					mul: 50, //depth of sweep
					add: 500 //range of sweep
				)
			)
		),
		0,
		0.1 //volume, stay below 0.2
	);
	//delay
	CombN.ar(i,
		3.0, //max delay
		1.35, //actual delay, stay below max delay
		6, //delay decay
		add: i
	)
}.play

)

//////////


// Second patch. You can run them at the same time, or several
// instances of the same patch.

( // <- double click the parenthesis
{
Mix.ar(
 Array.fill(5, // not too many values, could crash
   {Pan2.ar(
   SinOsc.ar(SinOsc.ar(1/10, rrand(0, 6.0), 200, 500)),
   1.0.rand)}
 )
)*0.02
}.play
)

// This one controls the three dimensions of sound: pitch, amp, and timbre.

(
{
var trig, out, delay;
trig = Impulse.kr(6); // trigger rate
out = Blip.ar(
 TRand.kr(48, 72, trig).midicps, // range, in midi, of pitches
 TRand.kr(1, 12, trig), // range of timbre
 max(0, TRand.kr(-0.5, 0.4, trig)) // amplitudes
);
out = Pan2.ar(out, TRand.kr(-1.0, 1.0, trig));
out = out*EnvGen.kr(Env.perc(0, 1), trig);
out = Mix.ar({out}.dup(6))*0.2;
delay = CombL.ar(out, 2.0, 4/6, 6);
}.play
)

////////Anthony's modification


(
{
var trig, out, delay, play;
trig = SinOsc.kr(18000, 0.2, 0.5, 0.25);
trig = Dust.kr(trig, 0.5);
trig = Impulse.kr(TRand.kr(75, 150, trig));

out = Blip.ar(
 TRand.kr(48, 72, trig).midicps,
 TRand.kr(1, 12, trig),
 max(0, TRand.kr(-0.5, 0.4, trig))
);

out = Pan2.ar(out, TRand.kr(-1.0, 1.0, trig));
out = out*EnvGen.kr(Env.perc(0, 1), trig);
out = Mix.ar({out}.dup(6))*0.2;

delay = CombL.ar(out, 2.0, 4/6, 6);

play = delay;

FreeVerb.ar(play, MouseX.kr(0, 1), MouseY.kr(0, 1), 0.5, 0.8, 0)

}.play
)

// OK, two more; the first uses a Saw as a control (note the rising sound).
// The second illustrates how Dust can be used to trigger events.




(
{
Mix.ar(
 {Pan2.ar(
  Klank.ar(
   `[Array.fill(3, {exprand(1000, 10000)}),
     1, Array.fill(3, {rrand(1.0, 4.0)})],
     Dust.ar(1/3, 0.1)),
       LFTri.kr(rrand(3.0, 10.0)))}.dup(20)
) }.play;
)


//one more

(
{
var out, nums;
nums = 100;
out = Mix.fill(nums,
	{SinOsc.ar(exprand(100, 10000)) * SinOsc.ar(exprand(0.001, 1)) * 0.01});
Out.ar([0, 1], out)
}.play
)

