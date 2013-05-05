/*
s.
MUSC 4121/5121 Composition Assignment #1

Find some patches, they can be from the tutorial, help files,
example files, or found on the internet, and modify them or
run them as is.

Record your patches as sound files and create a composition by
sequencing them in the sequencer of your choice, GarageBand,
ProTools, Logic, etc.

Do not add any effects to your patches, but do use the volume
automation to create smooth entrances and endings of your
sound files.

When your sequence is complete, save it as a stereo audio file
in wave, aiff, or mp3 format (your sequencer will do this
automatically.

DUE: Tuesday, February 7
*/
a= Env.new([0,100],[1,1]);
//some free patches
s.boot;
(
{
	var exc, amp;
	amp = LFPulse.kr(5,0,1.5,0.002);//change the freq arg to change tempo
	exc = LPZ1.ar(GrayNoise.ar([amp,amp]));
	x = Klank.ar(`[FloatArray.fill(4, { rrand(160,200) }),
			10,
	FloatArray[1, 1, 1, 1]], exc);
}.play
)


////////

{SinOsc.ar([440,460])}.play;
{SinOsc.ar([880,900])}.play;
(
{
	var amp, my;
	amp = LFPulse.kr(0.5,0,0.5);
	my = MouseY.kr(400,3200);
	Mix.arFill(8, {
		var x;
		x = Formlet.ar(Dust.ar(12,[0.05,0.05]) * amp, my * exprand(0.5,2.0), 0.005, 0.1);
		AllpassN.ar(x, 0.05,0.05.rand, 8);
	});
}.play;
)

//////////////////////////////////////////////////////////////////////

(
    // strummable guitar
    // use mouse to strum strings
{
	var pitch, mousex, out;
	// e a d g b e
	pitch = [ 52, 57, 62, 67, 71, 76];
	mousex = MouseX.kr;
	out = Mix.arFill(pitch.size, { arg i;
		var trigger, pluck, period, string;
		// place trigger points from 0.25 to 0.75
		trigger = HPZ1.kr(mousex > (0.25 + (i * 0.1))).abs;
		pluck = PinkNoise.ar(Decay.kr(trigger, 0.05));
		period = pitch.at(i).midicps.reciprocal;
		string = CombL.ar(pluck, period, period, 4);
		Pan2.ar(string, i * 0.2 - 0.5);
	});
	LPF.ar(out, 12000);
	LeakDC.ar(out);
}.play;
)
//Chimes
(
{
Mix.ar(
 {Pan2.ar(
  Klank.ar(
   `[Array.fill(3, {exprand(1000, 10000)}),
     1, Array.fill(3, {rrand(1.0, 4.0)})],
     Dust.ar(1/3, 0.1)), //First arg = freq
       LFTri.kr(rrand(3.0, 3.0)))}.dup(20)
) }.play;
)

(
{
var out, nums;
nums = 100;
out = Mix.fill(nums,
	{SinOsc.ar(exprand(100, 10000)) * SinOsc.ar(exprand(0.05, 1)) * 0.01});
Out.ar([0, 1], out)
}.play
)