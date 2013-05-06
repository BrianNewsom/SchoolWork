s.makeWindow.boot;

/*
A Simple SynthDef Review

SyntDef is one of the more complicated classes in SC and as
a result is very powerful. Let's review the process of creating
SynthDefs and then using them in a piece.

First we'll start with a very simple patch.
*/

(
{SinOsc.ar(400, 0, 0.5, 0)}.play
)

//add variables in the argument list

(
{
	var freq, vol;
	freq = 400;
	vol = 0.5;
	SinOsc.ar(freq, 0, vol, 0)}.play
)

//add an output bus for 2 channel sound

(
{
	var freq, vol;
	freq = 400;
	vol = 0.5;
	Out.ar([0,1], SinOsc.ar(freq, 0, vol, 0))
	}.play
)

//same patch as above except SinOsc is wrapped in a variable

(
{
	var freq, vol, osc;
	freq = 400;
	vol = 0.5;
	osc =  SinOsc.ar(freq, 0, vol, 0);
	Out.ar([0,1],osc)
	}.play
)

//Now let's turn this temp synth into a SynthDef

(
SynthDef("sophia", //create and name the SythDef
{
	var freq, vol, osc;
	freq = 400;
	vol = 0.5;
	osc =  SinOsc.ar(freq, 0, vol, 0);
	Out.ar([0,1],osc)
	}).play  //matching parens from the SynthDef at the top
)

//Change the variablesfor freq and vol in to arguments
//& load the SynthDef into the server

(
SynthDef("sophia",
{

	arg freq = 400, vol = 0.5;
	var osc;
	osc = SinOsc.ar(freq, 0, vol, 0);
	Out.ar([0,1],osc)
	}).send(s)  //send the synth definition to the server
)

//Play the SynthDef

Synth("sophia");

//wrap the Synth into a vaiable

a = Synth("sophia");
a.free;

//change pitch and volume

a = Synth("sophia");
a.set(\freq, 800);
a.set(\freq, 200);
a.set(\freq, 300);
a.set(\freq, 500);
a.set(\freq, 800, \vol, 1.0);
a.set(\freq, 1600, \vol, 0.2);
a.set(\freq, 400, \vol, 0.5);
a.free;

