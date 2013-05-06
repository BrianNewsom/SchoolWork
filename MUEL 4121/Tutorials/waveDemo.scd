s = Server.local.makeWindow;

//Bflat sine wave

(
{
	x = SinOsc.ar(466.16, 0, 0.5, 0);
	Out.ar([0,1], x)
	 }.scope;
)

//with freq and amp control

(
{
	var freq, amp;
	freq = MouseX.kr(40,10000);
	amp = MouseY.kr(0, 1);
	x = SinOsc.ar(freq, 0, amp, 0);
	Out.ar([0,1], x)
	 }.scope;
)

//triangle wave

(
{
	x = LFTri.ar(466.16, 0, 0.5, 0);
	Out.ar([0,1], x)
	 }.scope;
)

///sawtooth

(
{
	x = Saw.ar(466.16, 0.5, 0);
	Out.ar([0,1], x)
	 }.scope;
)

//pulse wave

(
{
	x = Pulse.ar(466.16, 0.5, 0.5, 0);
	Out.ar([0,1], x)
	 }.scope;
)


//modulate duty cycle

(
{
	x = Pulse.ar(466.16, MouseX.kr(0, 1), 0.5, 0);
	Out.ar([0,1], x)
	 }.scope;
)


//env test
(
var e;
e = Env.new(
		[0.01, 0.9, 4.9, 9.9, 0.0]/10,
		[20, 30, 50, 30],
		[2, 4, 1, -3]);
e.plot;
)


//

//env testadsr
(
var e;
e = Env.new(
		[0.01, 0.9, 0.6, 0.6, 0.0],
		[2, 1, 5, 2],
		[0, 0, 0, 0]);
e.plot;
)


//

(
{
var e;
e = Env.new(
		[20, 880, 720, 720, 20],
		[2, 1, 5, 2],
		[0, 0, 0, 0]);

	SinOsc.ar(EnvGen.ar(e), 0, 0.1);//pitch envelope
	}.scope
)

//

(
{
var e;
e = Env.new(
		[0.01, 0.1, 0.09, 0.09, 0.001],
		[2, 1, 5, 2],
		[0, 0, 0, 0]);

	//SinOsc.ar(EnvGen.ar(e), 0, 0.1);//pitch envelope
	SinOsc.ar(880, 0, EnvGen.ar(e));//amplitude envelope
	}
.scope
)

//


//ting-noEnv
(
{
	SinOsc.ar(5200, 0, 0.1);//amplitude envelope
}.scope
)

/////tingEnv

(
{
var e;
e = Env.new(
		[0.9, 0.09, 0.04, 0.000],
		[0.0, 0.5, 3],
		[0, 0, -5]);

	SinOsc.ar(5200, 0, EnvGen.ar(e));//amplitude envelope
	}.scope
)

//anvil hit

(
{
var e;
var a;
e = Env.new(
		[0.1, 10, 8, 0.000],
		[0.01, 0.5, 3],
		[0, 0, -5]);

a = Env.new(
		[0.5, 0.09, 0.04, 0.000],
		[0.01, 0.5, 6],
		[0, 0, -5]);
 PMOsc.ar(1300, 550,EnvGen.ar(e), 0, EnvGen.ar(a)) }.scope; //

)

//

(
{
var e;
var a;
e = Env.new( //index
		[0.1, 20, 8, 0.000],
		[0.01, 0.5, 5],
		[0, 0, -5]);

a = Env.new(  //amplitude
		[0.5, 0.09, 0.04, 0.000],
		[0.01, 3.5, 6],
		[0, 0, -5]);
 PMOsc.ar(1300, 550,EnvGen.ar(e), 0, EnvGen.ar(a)) }.scope; //

)

//

(
{
var e;
var a;
var f;
e = Env.new( //index
		[0.1, 20, 18, 0.000],
		[0.01, 0.5,5],
		[0, 0, -5]);

a = Env.new(  //amplitude
		[0.01, 0.1, 0.04, 0.000],
		[3.01, 3.5, 6],
		[0, 0, -5]);
f = Env.new(  //frequency
		[20, 1800, 320, 0],
		[0.01, 3.5, 6],
		[0, 0, -5]);
 PMOsc.ar(EnvGen.ar(f), 550,EnvGen.ar(e), 0, EnvGen.ar(a)) }.scope; //

)




///channel arrays

(
	{
	[Saw.ar(XLine.kr(1, 23000, 120), 0.1, 0.1, 0.1),
	Saw.ar(XLine.kr(2, 24000, 120), 0.1, 0.1, 0.1)]
	}.scope;
)

/////////

(
{ Pan2.ar(Saw.ar(XLine.kr(200, 15000, 20), 0.1), FSinOsc.kr(0.5));}.scope;
)

//same patch as above

(
{
	var freq, osc, pan;
	freq = XLine.kr(200, 15000, 20);
	osc = Saw.ar(freq, 0.5);
	pan = FSinOsc.kr(0.5);
	Pan2.ar(osc, pan)
	}.scope
)

////////
