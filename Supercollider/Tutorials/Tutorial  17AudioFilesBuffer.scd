s.makeWindow.boot;


/*
Audio Files and Buffers

Music Concrète

The most common definition for concrète music, what you will hear in an electro-acoustic music
course, is composition using recordings of real sounds as raw material. This definition takes its
meaning partly as a distinction from analog electronic sounds which are purely  electronic. The
attraction of concrète is the richness and complexity of the source. The sounds have a depth
that is difficult to reproduce with pure electronics.

 The second perhaps more accurate definition, which I like the more I think of it, is any  recorded
 sound. It is concrète because it will never change. Every performance will be exactly the same.
 A recorded symphony is analogous to a statue; set in stone. This definition reminds us that live
 music has a dimension recorded pieces do not; the potential for growth  and change. A written
 work that has to be realized is not the performance, but the potential for a performance, or a failed
 performance, or a brilliant performance, or in the case of aleatory and improvisation, something
 completely new, never heard before. I believe too  many people equate a recording with a
 performance. In a sense it has tainted our expectations: we attend a concert expecting what
 we heard on the CD.

 This chapter could have been titled sound file manipulation but I use concrète in perhaps an
 ironic sense because the real time dynamic controls available in SC allow us to take manipulation
 of concrète audio out of the realm of classic concrète in the second sense; not set in stone, but
 always evolving.
//Frame = 1 sample
//Sample Rate = 44.1 khz. that many samples per 1 second of mono sound
See also acousmatic music: http://en.wikipedia.org/wiki/Acousmatic_music

Buffers

Before processing audio it needs to be loaded into a memory buffer on the server. After audio  is loaded
into a buffer, either from a sound file on disk or from an input source, it is then available for processing,
quotation, or precise playback manipulation.

The first line below reads audio from a sound file. The arguments for  Buffer are the server where the
audio is loaded (think of it as a tape deck), and the sound file name (see the discussion on file
pathnames above).

Check the post window after running the first line. If the file was buffered correctly it should display
Buffer(0, -1, 1, sounds/XXXX). The information displayed is buffer number, number of frames,
channels, and pathname. You can also retrieve these values using
bufNum,  numChannels, path, and numFrames.

The arguments for PlayBuf are number of channels and buffer number.

Loading Audio into and Playing From a Buffer
*/
s.boot;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav"); // remember to free the buffer later.

c = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav", numFrames: 44100); // one second

/*
"a11wlk01.wav" is a sound file allready copied into the "sounds" folder
in the SuperCollider directory. If you have your own sound files that you wish to
manipulate, simply copy them into the sounds folder. Make sure that you have the
following file path in the Buffer.read: "sounds/yourSoundFileHere.wav"

can also be: "sounds/yourSoundFileHere.aif"

Note: When working in the CAML labs, you will not be able to copy files into
the sounds folder as it is in a locked partition. Possible work-arounds....
*/



// check data:
[b.bufnum, b.numChannels, b.path, b.numFrames].postln;

[c.bufnum, c.numChannels, c.path, c.numFrames].postln;

{PlayBuf.ar(1, 0)}.play(s); // Your buffer number may differ

{PlayBuf.ar(1, 1)}.play(s); // one second playback from c

/*
There is a GUI to inspect your sound file.
*/

(
w = Window.new("soundfile test", Rect(200, 200, 800, 400));
a = SoundFileView.new(w, Rect(20,20, 700, 60));

f = SoundFile.new;
f.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
f.inspect;

a.soundfile = f;
a.read(0, f.numFrames);
a.elasticMode = true;

a.timeCursorOn = true;
a.timeCursorColor = Color.red;
a.timeCursorPosition = 2050;
a.drawsWaveForm = true;
a.gridOn = true;
a.gridResolution = 0.2;

w.front;

)
/*
A frame is a single sample from all channels. If your sound file is mono then a frame
is a single sample. If it is stereo then a frame has two samples; from both the left and right
channels. If your file has 8 channels then a frame contains 8 samples. The number of
frames per second is the sample rate, e.g. 44,100 per second. If –1 is given for the number
of frames it reads all the frames in the file.

You can also record to a buffer from any input.  (Check your sound settings in the system preferences.)
You can record over an existing buffer, e.g. the ones we just created above, but it is more
likely you  will want a new one, which has to be created, or allocated before hand. The size
of the buffer is the sample rate * number of seconds.

To record, set the input source (using In.ar) and designate the buffer number. You can either  check the
post window to get the correct buffer number, or use d.bufnum as shown below. If you are using an
external mic mute your output or use headsets to avoid feedback.

It seems incorrect to use the  play message to record, but think of it as hitting the record and play
buttons on a cassette recorder.

We will look at real-time processing of live audio later.

Loading Audio into a Buffer from Live Audio Source
*/
d = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer

{RecordBuf.ar(SoundIn.ar(0), d.bufnum, loop: 0)}.play;

{PlayBuf.ar(1, d.bufnum, -1.0, loop: 1)}.play(s);

d.free;


/*
PlayBuf and RecordBuf have a loop argument, set to 0 (no loop) by default. To loop playback, set this
value to 1. In the case of RecordBuf a loop is applied to playback and record. There are two additional
arguments that affect the recording process: recLevel and preLevel. The first is the level of the source
as it is recorded. The second is the level the existing loop (pre-recorded material) is mixed when repeated. If, for example, the preLevel is set to 0.5 it will slowly fade away with each repetition.

One strategy for looping material is to create files that are the length you want the loops to be and play
them using PlayBuf with loop on. I think this is inefficient and less flexible; you would have to create a
file for each loop. Also, once your loops are defined they won't  change with each performance and it is
harder to change the loop in real time, e.g. augmentation, diminution, (not just playing the loop slower or
faster, but lengthening it by adding more material to the loop) or shifting in time. It is better to load an
entire concrète  example into a buffer then loop selections using BufRd. The arguments for BufRd are
number of channels, buffer number, phase, and loop. Phase is the index position of the file for playback
(index in frames) and can be controlled with an audio rate source.

In the days where concrète composition was well established we were limited to a tape, decks, and play heads.
You could play back at speeds available on the deck, or you could rock the reels back and forth by  hand.
One clever composition called for the playback head to be removed from the deck and moved by hand over
magnetic tape allowing the performer to "draw" the playback on a patch of magnetic tape. It seemed like an
interesting idea but the precise tolerance of the head  position was impossible to set up correctly and it was
not very effective. Here is the SC version of that idea. This example assumes you have loaded a 10 second
 example into a buffer. The phase control has to be an audio rate, so I use K2A to convert MouseX to an audio  rate.


Playback with Mouse
*/
b.free; b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav", 0, 10*44100);

{BufRd.ar(1, b.bufnum, K2A.ar(MouseX.kr(0, 4*44100)))}.play
/*
Our next goal is to loop sections of the file. So at 44100 kHz sampling rate a two second loop would have
88200 frames. If we wanted to begin the loop 1.5 seconds into the file then the  start point of the loop would
be 66150. The end point then would be 66150 + 88200, or 154350. Still using the mouse as a control we would
just have to enter those two numbers for start and end. Better yet, use a variable for the sample rate and multiply
it by the number of  seconds.

To create a simple loop on the same section as above we use an LFSaw (but see also Phasor, which I also
tried but didn't feel it was as flexible) which generates a smooth ramp  from –1 to 1.

There are two critical values for controlling the playback position: First the scale (and offset) of the LFSaw
have to be correct for the number of frames; second, the rate of the saw has to  be correct for normal
playback speed. The help file uses two utilities for this: BufFrames which returns the number of frames
in a buffer and BufRateScale which returns the correct rate in Hz for normal playback speed of a given buffer.
But both of these assume you are playing the entire file. We are looping sections, so we have to do our own
calculations.

It would be easier to define the loop points in seconds rather than samples. To convert seconds to frames
multiply by the sample rate. Defining loops using time requires that you know the length of the entire file.
Exceeding the length won't cause a crash, it will just loop  around to the beginning. Not a bad thing, just
perhaps not what you want, maybe a good thing, so I'll leave that option open. You can also define the loops
as a percentage of the entire file. See below for an example.

(When first trying these examples I was terribly confused about why an LFSaw that had a scale equal to the
total frames of the file, but had not yet been offset, would still play the file correctly. I was sure the LFSaw
was generating negative values. It was, but it was just  wrapping around back to the beginning of the file,
playing it from start to finish while the LFSaw was moving from –1 to 0, then again as it moved from 0 to 1.
So you could loop an entire file by only setting the scale to the total frames, but read on.)

The scale and offset of the LFSaw could be set in terms of seconds rather than frame number. Given a loop
beginning at 2" and ending at 6" the offset would be 4 and the scale 2. Or you could say that scale is
(length/2) + beginning, offset is length/2. With these settings the  LFSaw will move between 2 and 4.
Multiplying the entire LFSaw by the sample rate will return the correct frame positions.

I prefer using  LinLin which converts any linear set of values to another range. The arguments are input
(e.g. the ugen you want to convert), input low and high (i.e. the range of the input ugen by default), and
output low and high (what you want it converted to). It does the same  as an offset and scale, but is
clearer if you are thinking in terms of a range. So these two lines of code have the same result, but
with one important difference: with LinLin you can invert the signal (useful for reverse playback) with
values such as –1, 1, 1000, 700. The last  example won't play, but shows how the LFSaw needs to be
setup to correctly sweep through a range of samples.


LinLin, LFSaw for Sweeping Through Audio File
*/

// Same thing:

{SinOsc.ar(LinLin.kr(SinOsc.kr(5), -1, 1, 700, 1000))}.play

{SinOsc.ar(SinOsc.kr(5, mul: 150, add: 850))}.play

// Will sweep through 66150 110250, or 1.5" to 2.5" of audio file

LinLin.ar(LFSaw.ar(1), -1, 1, 1.5, 2.5)*44100

/*
We have one more complicated calculation before doing a loop; playback rate. The rate of playback is
going to be controlled by the frequency of the LFSaw. How fast do we want it to sweep through the given
samples? If the length of the loop is 1 second, then we would want the LFSaw to move through all the
values in 1 second, so the frequency would be 1. But if the length of the loop is 2 seconds, we would
want the saw move through the samples in 2  seconds. Remember that duration and frequency are
reciprocal. So for an LFSaw duration of 2 seconds, frequency would be 1/2, or 1/duration.

We're not done yet. 1/duration is normal playback. If we want a faster or slower playback  rate we would
multiply the frequency by that ratio: ratio*(1/duration), or ratio/duration. So 2/duration would playback
twice as fast. 0.5/duration half as fast.

When you are looping possibly random points in the file (which by now you know I'm heading for) you have
potential for clicks. If the beginning point is a positive sample in the wave and the end is a negative the
result is a sharp transition; the equivalent to a non-zero  crossing edit. This problem is corrected with an
envelope the length of the loop with a fast attack and decay, and a gate equal to the frequency of the loop.
Ok, the example.

We also want the LFSaw to begin in the middle of its phase, which is where it  reaches its lowest value,
so the phase of the saw is set to 1 radian. This is not an issue with Phasor, but there was some other
problem when I did an example with it.

Looping a Section of a File
*/

b = Buffer.read(s, Platform.resourceDir +/+"sounds/a11wlk01.wav") //check your buNum

(
{
var bufNum = 0, srate = 44100, start = 0, end = 1, duration, rate = 1;
// Use these lines for proportional lengths
//var bufNum = 0, srate = 44100, start = 0.21, end = 0.74,
// rate = 1, duration, total;
// total = BufFrames.kr(bufNum)/44100;
// end = end*total; start = start*total;
duration = abs(end - start);
BufRd.ar(1, bufNum, // Buffer 0
	LinLin.ar(
		LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
	)*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
		gate: Impulse.kr(1/duration));
}.play
)
/*
Magically, the same example works with proportional values or a percentage of the total length of a
file (commented out above). In this case the ugen BufFrames is useful when  divided by sample rate
(to return total length of the file in seconds). Of course, when using this method length should not
exceed 1.0 and start + length should not exceed 1.0 (but don't let me stop you—it wraps around).

Looper
*/

(
{
var bufNum = 0, srate = 44100, start = 0.21, end = 0.74,
	rate = 1, totalDur = 20, pan = 0;
var out, duration, total;
start = [0.3, 0.2]; end = [0.2, 0.3];
total = BufFrames.kr(bufNum)/44100;
end = end*total; start = start*total;
duration = abs(end - start);
BufRd.ar(1, bufNum, // Buffer 0
	LinLin.ar(
		LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
	)*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
		gate: Impulse.kr(1/duration));
}.play
)

/*
Enough work, on to the fun. You might place this looper in a SynthDef with a task running  different
examples, but what I want to demonstrate would be more complicated as such, so the example
above is just a stereo array for start and end. Here are some things to try (change the start and end
values, remember these are proportional, i.e. percentage of total audio file  time):

– forward and backward loops of the same material as shown above (start = [0.2, 0.3];  end = [0.3, 0.2];)

– loops with slightly different lengths so that they slowly move out, then eventually go back into
phase, e.g. every tenth time (start = [0.2, 0.2]; end = [0.31, 0.3];)

– different lengths but a given ratio, such as 3/2 (start = 0.2 for both, end = 0.3 for one, so the length
is 0.1, then the second length would be 0.15 so end is start + 0.15, or 0.35) so that one plays 3 times
while the other plays 2, like an interval–this is a pretty  cool effect with short examples (end = [0.35, 0.3])

– expand the playback rate into an array achieving effects similar to different lengths

– combine different playback rates with lengths

Of course the audio file or live input is a signal and can be modulated in any of the ways previously
 discussed. Following are a few ideas. They all assume you are using buffer 0, and  that you are recording
 live audio to it, or have loaded a sound file into it.


Modulating Audio Buffers
*/

// FM Modulation

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1, signal;
duration = abs(end - start);
// or
// end = [2.3, 3.5];
signal = BufRd.ar(1, bufNum, // Buffer 0
	LinLin.ar(
		LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
	)*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
		gate: Impulse.kr(1/duration));

SinOsc.ar(LFNoise1.kr([0.4, 0.43], mul: 200, add: 200))*signal;
// or
// SinOsc.ar(LFNoise0.kr([12, 15], mul: 300, add: 600))*signal;
// or
// SinOsc.ar(LFNoise1.kr([0.4, 0.43], mul: 500, add: 1000))*signal;

}.play(s)
)


// Pulsing in and out USE

(
{
var bufNum = 0, srate = 44100, start = 0, end = 8, duration, rate = 1;
var pulse;
pulse = [6, 10];
duration = abs(end - start);
BufRd.ar(1, bufNum, // Buffer 0
	LinLin.ar(
		LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
	)*EnvGen.kr(Env.linen(0.01, 0.3, 0.01), timeScale: duration/pulse,
		gate: Impulse.kr(pulse/duration));
}.play(s)
)

// Filtered

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1, signal;
duration = abs(end - start);
signal = BufRd.ar(1, bufNum, // Buffer 0
	LinLin.ar(
		LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
	)*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
		gate: Impulse.kr(1/duration));
RLPF.ar(signal, LFNoise1.kr([12, 5], mul: 700, add: 1000), rq: 0.05)*0.2;
}.play(s)
)

// Modulating one with another, dry in left, dry in right, modulated center
// Listen for a while for full effect

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1, signal;
end = [2.5, 2.9];
duration = abs(end - start);
signal = BufRd.ar(1, bufNum, // Buffer 0
	LinLin.ar(
		LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
	)*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
		gate: Impulse.kr(1/duration));
(signal*0.1) + (signal.at(0) * signal.at(1))
}.play(s)
)

//Phasing

//start together
Server.default = s = Server.internal.boot;

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
var n;
n = 12;
{Mix.fill(n, { arg i;

			Pan2.ar(
	                PlayBuf.ar(1, b.bufnum, 1.0 + (XLine.kr(0.0013,0.13,120) * i), 0, 0, b.bufnum.size-2),
				2.0/(1-n) * i + 1)})

}.scope(1);
)


/*
These examples are from the PlayBuf help file and use SynthDefs
*/

(
// read a whole sound into memory
s = Server.local;

b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");
)

(
SynthDef("help-PlayBuf",{ arg out=0,bufnum=0;
	Out.ar(out,
		PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum))
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)

/*
Note again that the number of channels must be fixed for the SynthDef, it cannot vary depending
 on which buffer you use.
*/

// loop is true
(
SynthDef("help-PlayBuf",{ arg out=0,bufnum=0;
	Out.ar(out,
		PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum),loop: 1.0)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)


// trigger one shot on each pulse
(
SynthDef("help-PlayBuf",{ arg out=0,bufnum=0;
	var trig;
	trig = Impulse.kr(2.0);
	Out.ar(out,
		PlayBuf.ar(1,b.bufnum,BufRateScale.kr(bufnum),trig,0,0)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)

// trigger one shot on each pulse
(
SynthDef("help-PlayBuf",{ arg out=0,bufnum=0;
	var trig;
	trig = Impulse.kr(XLine.kr(0.1,100,30));
	Out.ar(out,
		PlayBuf.ar(1,b.bufnum,BufRateScale.kr(bufnum),trig,5000,0)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)



// mouse control of trigger rate and startpos
(
SynthDef("help-PlayBuf",{ arg out=0,bufnum=0;
	var trig;
	trig = Impulse.kr(MouseY.kr(0.5,200,1));
	Out.ar(out,
		PlayBuf.ar(1,b.bufnum,BufRateScale.kr(bufnum),trig,MouseX.kr(0,BufFrames.kr(bufnum)),1)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)


// accelerating pitch
(
SynthDef("help-PlayBuf",{ arg out=0,bufnum=0;
	var rate;
	rate = XLine.kr(0.1,100,60);
	Out.ar(out,
		PlayBuf.ar(1, bufnum, rate, 1.0,0.0, 1.0)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)


// sine wave control of playback rate. negative rate plays backwards
(
SynthDef("help-PlayBuf",{ arg out=0,bufnum=0;
	var rate;
	rate = FSinOsc.kr(XLine.kr(0.2,8,30), 0, 3, 0.6);
	Out.ar(out,
		PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum)*rate,1,0,1)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)

// zig zag around sound
(
SynthDef("help-PlayBuf",{ arg out=0,bufnum=0;
	var rate;
	rate = LFNoise2.kr(XLine.kr(1,20,60), 2);
	Out.ar(out,
		PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum)*rate,1,0,1)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)


/*
The following examples are from the TGrains help file. Granulation
of sound files is a fascinationing processand the results can be very cool.


TGrains		buffer granulator

Triggers generate grains from a buffer. Each grain has a Hanning envelope (sin^2(x) for x from 0 to pi) and is panned between two channels of multiple outputs.

TGrains.ar(numChannels, trigger, bufnum, rate, centerPos, dur, pan, amp, interp)

	numChannels - number of output channels.
	trigger - at each trigger, the following arguments are sampled and used
		as the arguments of a new grain.
		A trigger occurs when a signal changes from <= 0 to > 0.
		If the trigger is audio rate then the grains will start with sample accuracy.
	bufnum - the index of the buffer to use. It must be a one channel (mono) buffer.
	rate   -  1.0 is normal, 2.0 is one octave up, 0.5 is one octave down
			-1.0 is backwards normal rate ... etc.
		Unlike PlayBuf, the rate is multiplied by BufRate, so you needn't do that yourself.
	centerPos - the position in the buffer in seconds at which the grain envelope will reach
			maximum amplitude.
	dur    -   duration of the grain in seconds.
	pan    -   a value from -1 to 1. Determines where to pan the output in the same manner as PanAz.
	amp   - amplitude of the grain.
	interp - 1,2,or 4. Determines whether the grain uses (1) no interpolation, (2) linear interpolation,
			or (4) cubic interpolation.
*/

(
s = Server.internal;
Server.default = s;
s.boot;
)


s.sendMsg(\b_allocRead, 10, Platform.resourceDir +/+ "sounds/a11wlk01.wav");


(
{
	var b = 10, trate, dur, rate;
	trate = MouseY.kr(2,200,1);
	dur = 4 / trate;
	rate = Dseq([10, 1, 1, 0.5, 0.5, 0.2, 0.1], inf);
	TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0,BufDur.kr(b)), dur, Dseq([-1, 1], inf), 0.1, 2);
}.scope(zoom: 4);
)

(
{
	var b = 10, trate, dur, clk, pos, pan;
	trate = MouseY.kr(8,120,1);
	dur = 12 / trate;
	clk = Impulse.kr(trate);
	pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
	pan = WhiteNoise.kr(0.6);
	TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)

// 4 channels
(
{
	var b = 10, trate, dur, clk, pos, pan;
	trate = MouseY.kr(8,120,1);
	dur = 12 / trate;
	clk = Impulse.kr(trate);
	pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
	pan = WhiteNoise.kr(0.6);
	TGrains.ar(4, clk, b, 1, pos, dur, pan, 0.1);
}.scope(4, zoom: 4);
)

(
{
	var b = 10, trate, dur, clk, pos, pan;
	trate = MouseY.kr(8,120,1);
	dur = 4 / trate;
	clk = Dust.kr(trate);
	pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
	pan = WhiteNoise.kr(0.6);
	TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)



(
{
	var b = 10, trate, dur, clk, pos, pan;
	trate = LinExp.kr(LFTri.kr(MouseY.kr(0.1,2,1)),-1,1,8,120);
	dur = 12 / trate;
	clk = Impulse.ar(trate);
	pos = MouseX.kr(0,BufDur.kr(b));
	pan = WhiteNoise.kr(0.6);
	TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)


(
{
	var b = 10, trate, dur, clk, pos, pan;
	trate = 12;
	dur = MouseY.kr(0.2,24,1) / trate;
	clk = Impulse.kr(trate);
	pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
	pan = WhiteNoise.kr(0.6);
	TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)

(
{
	var b = 10, trate, dur, clk, pos, pan;
	trate = 100;
	dur = 8 / trate;
	clk = Impulse.kr(trate);
	pos = Integrator.kr(BrownNoise.kr(0.001));
	pan = WhiteNoise.kr(0.6);
	TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)

(
{
	var b = 10, trate, dur, clk, pos, pan;
	trate = MouseY.kr(1,400,1);
	dur = 8 / trate;
	clk = Impulse.kr(trate);
	pos = MouseX.kr(0,BufDur.kr(b));
	pan = WhiteNoise.kr(0.8);
	TGrains.ar(2, clk, b, 2 ** WhiteNoise.kr(2), pos, dur, pan, 0.1);
}.scope(zoom: 4);
)




(
{
	var b = 10, trate, dur;
	trate = MouseY.kr(2,120,1);
	dur = 1.2 / trate;
	TGrains.ar(2, Impulse.ar(trate), b, (1.2 ** WhiteNoise.kr(3).round(1)), MouseX.kr(0,BufDur.kr(b)), dur, WhiteNoise.kr(0.6), 0.1);
}.scope(zoom: 4);
)




// demand ugens as inputs
(
{
	var trate, dur, z, d;
	trate = MouseX.kr(1, 100, 1);
	d = { Dwhite(0.1, 0.2, 1) };
	z = {
		Drand([Dgeom(0.1, 1 + d.value, Diwhite(20, 40)), Dgeom(1, 1 - d.value, Diwhite(20, 40))])
	};
	TGrains.ar(2,
		Impulse.ar(trate),
		bufnum: 10,
		rate: Dseq([1, 1, z.value, 0.5, 0.5, 0.2, 0.1, 0.1, 0.1, 0.1], inf) * 2 + 1,
		centerPos: Dseq(z.dup(8), inf),
		dur: Dseq([1, d.value, 1, z.value, 0.5, 0.5, 0.1, z.value] * 2, inf) / trate,
		pan: Dseq([1, 1, 1, 0.5, 0.2, 0.1, 0, 0, 0], inf) * 2 - 1,
		amp: Dseq([1, 0, z.value, 0, 2, 1.0, 1, 0.1, 0.1], inf)
	);
}.scope(zoom: 4);
)

