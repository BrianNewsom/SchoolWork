s.makeWindow.boot;
s.boot;
/*
Boolean & MIDI


Control Using if, do continued, Arrays, MIDIIn


Control message "if"

Artificial intelligence and computer-assisted composition begin with logic controls. That is,
telling the machine what to do in certain circumstances. If you are thirsty do open the fridge.
If there is no beer then do go to the store. If you have enough money do buy 2 six packs. Do
come home and open the fridge again. If there is cheese and leftover tapas do choose between
the two and have a snack. Don't use marinated tofu. There are several methods of iteration and
control such as while, for, and forBy, but do and if are the most common.

The if message or function takes three arguments: an expression to be evaluated, a true
function, and a false function. It evaluates the expression to be true or false and returns the
results of the first function if true, the second if false.

if(expression, {true function}, {false function})

The true or false often results form a comparison of two values separated by the operators
covered earlier such as "<" for less than, ">" for greater than, "==" for equals, etc. (Note the
difference between two equals signs and one. "=" means store this number in the variable,
"==" means "is it equal to?"). Run both examples of code below. The first one evaluates a
statement which returns true (because 1 does indeed equal 1) so it runs the first function. The
second is false, so the false function is run.







if examples
*/

if(1 == 1, {"true statement";},{"false statement";})

if(1 == 4, {"true statement";},{"false statement";})

// Commented:
(
if(
	1 == 1, 	//expression to be evaluated; "1 is equal to 1" true or false?
	{"true statement";},		//if the statement is true run this code
	{"false statement";}		//if it is false run this code
)
)
/*


Here are other Boolean operators
< less than
> greater than
<= less than or equal to
>= greater than or equal to
!= not equal to
== equal to

The message "or" combines two statements, returning true if either are correct; or(a > 20, b >
100). The message "and" combines two statements, returning true only if both are correct;
and(a > 20, b > 100). The word true is true and false is false.




if examples
*/

if((1 == 1).and(5 < 7), {"both are true"},{"maybe only one is true";}).postln

if((1 == 20).and(5 < 7), {"both are true";},{"one or both are false";}).postln

if((1 == 20).and(24 < 7), {"both are true";},{"one or both are false";}).postln

if((1 == 4).or(true), {"true is always true";},{"1 does not equal 4";}).postln

if(false.or(true), {"true is always true";},{"true wins with or";}).postln

if(false.and(true), {"true is always true";},{"but false wins with and";}).postln

if(or(10 > 0, 10 < 0), {34},{78}).postln

if((1 == 1).and((10 > 0).or((5 < 0).or(100 < 200))), {78},{88}).postln

/*


These isolated numerical examples seem moot without a context (i.e. why would I ever use
the expression 10 > 0? and why would you just post "true statement" or "false statement").
The if function is usually used in combination with some iterative process such as do. Here is
a real musical example. The code below begins at MIDI 60 (C4). It then picks a new MIDI
interval, adds it to m and returns that new value. Watch the results.



do 50 MIDI intervals
*/

(
m = 60;
50.do(
	{
	m = m + [6, 7, 4, 2, 11, 8, -2, -6, -1, -3].choose;
	m.postln;
	}
)
)

/*


I've biased the choices so that there are more intervals up than down. So eventually the MIDI
values exceed a reasonable range for most instruments. Even if I carefully balanced the
choices it is conceivable that a positive value is chosen 20 times in a row. The if statement
below checks the value during each iteration and and increases it by two octaves if below 36.



do 50 MIDI intervals
*/

(
m = 60;
50.do(
	{
	var next;
	next = [6, 17, 14, 2, 11, 8, -12, -16, -1, -3].choose;
	"next interval is : ".post; next.postln;
	m = m + next;
	"before being fixed: ".post; m.post;
	if(m > 72, {m = m - 24});
	if(m < 48, {m = m + 24});
	" after being fixed: ".post; m.postln;
	}
)
)

/*


When writing a little piece of code like this it is worth poking around in SC to see if a
function already exists that will do what you want. There is wrap, which wraps a value
around, but in this example we are buffering, not wrapping. So in this case we really do need
the extra lines of code.

Below shows a do iteration over an array of pitch classes with an if test to look for C, D, or E.
The computer doesn't understand these as actual pitches  but just text. Even so it does know
how to compare to see if they are equal.



pitch class do
*/

(
["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"].do(
	{arg item, count;
		if((item == "C").or(item == "E").or(item == "G"), //Boolean test
			{item.post; " is part of a C chord.".postln;}, //True function
			{item.post; " is not part of a C chord".postln;} //False function
			)
		}
	)
)

/*


You might say we have taught the computer a C chord. This is where AI begins.

A series of if statements can be used to define a region on the screen. When the mouse enters
the region with an x greater than 0.3, but less than 0.5, and a y that is greater than 0.3, but
less than 0.7 (all conditions are "true") it generates a positive value, or a trigger. In this
example the * is equivalent to and. There are no true or false functions, just the values 1 (on)
and 0 (off).



Mouse Area Trigger
*/
(
{


var aenv, fenv, mgate, mx, my;
mx = MouseX.kr(0, 1);
my = MouseY.kr(0, 1);
mgate = if((mx>0.3) * (mx<0.5) * (my>0.3) * (my<0.7), 1, 0);//no true or false
                                                           //functions
aenv = EnvGen.kr(Env.asr(0.1, 0.5, 2), mgate);
fenv = EnvGen.kr(Env.asr(1, 1, 2), mgate, 1000, 100);
RLPF.ar(Saw.ar(100)*aenv, fenv, 0.1)
}.play
)


/*


One nice trick with if is to control when to postln rather than post, which does not print a new
line:



new line
*/

(
100.do(
	{
		arg count;
		100.rand.post;
		if(count%10 == 9, //Every 9th time - % means modulo
			{" new line: ".postln;}, //print a carriage return
			{" : ".post;} //just " : " without a return
			);
	}
)
)

/*


while

The while function repeats the second argument (a function) until the first argument (an
evaluation function) returns a false. This is a dangerous tool for beginners. If you write a
condition that has no chance of ever returning false, SC will run forever. (This is often the
cause of many applications locking up.) The first example below shows a common error.
This line will repeat until the second function stores the value 10 in the variable a. But
10.rand picks numbers between 0 and 9, so it will never pick 10, and will run until you force
it to quit. It is therefore a good idea to put an additional condition that will stop it after a
specified number of repetitions. But if you're like me, I forget to include the c = c + 1 and it
crashes anyway.

The last line shows a typical use for while. This line should tell you how long it took to pick
the number 13 out of 100.



while
*/

a = 0; while({a != 10}, {a = 10.rand}) // save before doing this

// Safer?

c = 0; a = 0;
while({and(a != 10, c < 100)}, {a = 10.rand; c = c + 1;})


(
a = 0; c = 0;
while({(a != 13).and(c < 10000)}, {a = 100.rand; c = c + 1;});
c
)

/*


for, forBy

The "for" allows you to specify the start and end points of the iteration, and "forBy" includes an
argument for step value. In a previous example we built a patch with odd harmonics. The
counter was used to calculate each harmonic, but since it began at 0 we had to add 1 (counter
+1). We also had to include a bit of math for odd harmonics only. But with forBy the
calculation can be integrated.




for, forBy
*/

34.for(84, {|i| i.midicps.postln});

34.forBy(84, 5, {|i| [i, i.midicps].postln});

1.forBy(24, 2, {|i| [i, i*500].postln}); // odd harmonics

(  // additive square wave
{
o = 0;
1.forBy(24, 2, {|i| o = o + SinOsc.ar(i*500, mul: 1/i)});
o*0.4
}.scope
)



/*


MIDI


A popular 80s technology


(See the [UsingMIDI] helpfile for practical considerations and techniques for using MIDI in SC.
see helpfile: [MIDIResponder])



Sometimes you might want to control your syth patches with some sort of MIDI controller.

To initialize the MIDI out, run the following code.
*/



(
MIDIClient.init;
m = MIDIOut(0, MIDIClient.destinations.at(0).uid);
)





/*
To do a quick start for a one port MIDI  interface run this code.
*/



(
	MIDIIn.connect; 	// init for one port midi interface
// register functions:
	MIDIIn.noteOff = { arg src, chan, num, vel; 	[chan,num,vel / 127].postln; };
	MIDIIn.noteOn = { arg src, chan, num, vel; 	[chan,num,vel / 127].postln; };
	MIDIIn.polytouch = { arg src, chan, num, vel; 	[chan,num,vel / 127].postln; };
	MIDIIn.control = { arg src, chan, num, val; 	[chan,num,val].postln; };
	MIDIIn.program = { arg src, chan, prog; 		[chan,prog].postln; };
	MIDIIn.touch = { arg src, chan, pressure; 	[chan,pressure].postln; };
	MIDIIn.bend = { arg src, chan, bend; 			[chan,bend - 8192].postln; };
	MIDIIn.sysex = { arg src, sysex; 			sysex.postln; };
	MIDIIn.sysrt = { arg src, chan, val; 			[chan,val].postln; };
	MIDIIn.smpte = { arg src, chan, val; 			[chan,val].postln; };
)



/*

Playing notes on your MIDI keyboard

The technical problem is that every note on needs to save its synth object so that the note off message can end the right server-side node.
*/


(
var notes, on, off;

MIDIIn.connect;

notes = Array.newClear(128);  // array has one slot per possible MIDI note

on = Routine({
	var event, newNode;
	loop {
		event = MIDIIn.waitNoteOn;	// all note-on events
			// play the note
		newNode = Synth(\default, [\freq, event.b.midicps,
			\amp, event.c * 0.00315]);  // 0.00315 approx. == 1 / 127 * 0.4
		notes.put(event.b, newNode);	// save it to free later
	}
}).play;

off = Routine({
	var event;
	loop {
		event = MIDIIn.waitNoteOff;
			// look up the node currently playing on this slot, and release it
		notes[event.b].set(\gate, 0);
	}
}).play;

q = { on.stop; off.stop; };
)

// when done:
q.value;



/*
The MIDIIn help file contains a more elaborate example.


SuperCollider does not have a built-in class to handle this automatically. However, dewdrop_lib,
one of the third party libraries mentioned below, includes a small suite of classes designed for
 exactly this purpose. Users interested in this functionality may wish to examine that library.




MIDIIn reads input from a MIDI source. There are a number of ways this can be used. The
first is to trigger an instrument you have designed previously, as in this example (WARNING,
these examples are buggy.They will not stop playing even with cmd - period):



MIDI input to trigger SynthDef
*/

// First define this instrument

(
SynthDef("simpleInst",
{
arg midi = 60, vel = 60, inst;
inst = {
	SinOsc.ar(
		freq: (midi.midicps), //*(LFNoise0.kr(12) + 2).round(1),
		mul: vel/256)
	}.dup(5) *
	EnvGen.kr(Env.perc(0, 3), doneAction: 2);
Out.ar(0, inst)
}
).play;
)

// Then link it to MIDI input
(
MIDIIn.noteOn = {
arg  src, chan, midiNum, midiVelo;
Synth("simpleInst", [\midi, midiNum, \vel, midiVelo]);
};
)



/////////////////a couple more examples

(


SynthDef("bass",
{arg midi = 66, amp = 0.5, dur = 4, pan = 0, legato = 0.8, inst;

		inst = {Pan2.ar(
			Pulse.ar(midi.midicps, SinOsc.ar(4, 0, amp, 0.5), 0.3)
			*
			EnvGen.kr(Env.perc(0.1, dur*legato), doneAction: 2),
			pan)}*
	EnvGen.kr(Env.perc(0, 3), doneAction: 2);

			Out.ar(0, inst);


}).play;

)

// Then link it to MIDI input

(

x = MIDIIn.noteOn = {
arg  src, chan, midiNum, midiVelo;
Synth("bass", [\midi, midiNum, \vel, midiVelo]);
};
)



//////////plucked string

(
//First load the synth and save to disk


SynthDef("bindTest1",

{
		arg midi = 60, amp = 0.9, dur = 1, pan = 0, legato = 0.8,
		delayDecay = 5.0;
		var burstEnv, att = 0, dec = 0.001;
		var signalOut, delayTime;
		delayTime = [midi, midi + 12].midicps.reciprocal;
		burstEnv = EnvGen.kr(Env.perc(att, dec));
		signalOut = BrownNoise.ar(burstEnv*0.3)+PinkNoise.ar(burstEnv*0.4);
		signalOut = CombL.ar(signalOut, delayTime, delayTime,
			delayDecay, add: signalOut);
		DetectSilence.ar(signalOut, doneAction:2);
		Out.ar(0, signalOut)
	}
).play;
)

// Then link it to MIDI input

(
MIDIIn.noteOn = {
arg  src, chan, midiNum, midiVelo;
Synth("bindTest1", [\midi, midiNum, \vel, midiVelo]);
};


)





/*


To control any other instrument that has already been defined using SynthDef, just replace
the "simpleInst" with the instrument name and be sure to match the arguments with those
appropriate for that instrument.

The following example creates a split keyboard with two instruments.




Keyboard Split for two voices
pbend to cutoff, mod to rez, 7 to amp
// - matrix6k@somahq.com
*/





 (

SynthDef("funk",{ arg freq = 700, amp = 0.2, gate = 1, cutoff = 20000, rez = 1, lfospeed=0;
     var e,x,env,range,filterfreq;
	e = Env.new([0, 0.1, 0.1, 0], [0, 0.1, 0.1], 'linear', 2);
	env=Env.adsr(0.3,1,1,1);
	range = cutoff -1;
	filterfreq = SinOsc.kr(lfospeed,0, range, cutoff).abs;
	x = RLPF.ar(Mix.ar([
			Mix.arFill(2, {Saw.ar(freq *2 + 0.2.rand2, amp)}),
			Mix.arFill(2, {Saw.ar(freq *4+ 0.2.rand2, amp)})
			]),
			EnvGen.kr(env,gate)*filterfreq,
			rez);
     Out.ar([0,1],x * EnvGen.kr(e, gate, doneAction: 2))

}).add;

SynthDef("strings",{ arg freq = 700, amp = 0.2, gate = 1;
     var x,enve;
	enve = Env.new([0, 0.1, 0.1, 0], [2, 0.1, 1], 'linear', 2);
	x = RLPF.ar(Mix.ar([
					Mix.arFill(2, {Saw.ar(freq +2.rand2,0.6)}),
					Mix.arFill(2, {Saw.ar(freq *0.5 + 2.rand2,0.6)})
			]),
			6000,1);
     Out.ar([0,1],x * EnvGen.kr(enve, gate, doneAction: 2))

}).add;

)

//then...

(
var keys, cutspec, cutbus, rezspec, rezbus, lfospec, lfobus;
keys = Array.newClear(128);

MIDIClient.init;
MIDIIn.connect(0, MIDIClient.sources.at(0));

g = Group.new;

cutspec = ControlSpec(100,10000,\linear,0.001);
cutbus = Bus.new(\control,1,1,s);
cutbus.value = 10000;

rezspec = ControlSpec(1,0,\linear,0.001);
rezbus = Bus.new(\control,2,1,s);
rezbus.value = 1.0;

lfospec = ControlSpec(0,50,\linear,0.001);
lfobus = Bus.new(\control,3,1,s);

MIDIIn.control = {arg src, chan, num, val;
			if(num == 1,{
				rezbus.value = rezspec.map(val/127.0);
			});
			if(num == 7,{
				lfobus.value = lfospec.map(val/127.0).postln;
			});
			};
MIDIIn.bend = {arg src, chan, val;
			cutbus.value = cutspec.map(val/16383.0);
			};

MIDIIn.noteOn = {arg src, chan, num, vel;
	var node;
	if(num < 60, {
		node = Synth.tail(g, "funk", [\freq, num.midicps, \amp, vel/255]);
		node.map("cutoff",1,"rez",2,"lfospeed",3);

//		node = Synth.basicNew("funk",s);
//		s.sendBundle(nil,
//			node.addToTailMsg(g,[\freq, num.midicps, \amp, vel/255]),
//			node.mapMsg("cutoff",1,"rez",2,"lfospeed",3)
//		);
		keys.put(num, node)
	},{
		node = Synth.tail(g, "strings", [\freq, num.midicps, \amp, vel/255]);
		keys.put(num, node)
	});
};


MIDIIn.noteOff = {arg src, chan, num, vel;
    var node;
    node = keys.at(num);
    if (node.notNil, {
        keys.put(num, nil);
        s.sendMsg("/n_set", node.nodeID, "gate", 0);
        // or node.release
        // then free it ... or get the NodeWatcher to do it
    });
};

)


////////////MIDIdef

(
MIDIIn.connectAll;

SynthDef(\pianoish,{arg note,vel;
	var sig, env;

	env = EnvGen.kr(Env.perc,1,doneAction:2);

	sig = SinOsc.ar(note.midicps,0,vel.linlin(0,127,0.0,1.0));

	Out.ar(0,sig*env);
}).add;

MIDIdef.noteOn(\pianoish,{arg vel, note, chan;
	[vel,note,chan].postln;
	Synth(\pianoish,["note",note,"vel",vel]);
});
)