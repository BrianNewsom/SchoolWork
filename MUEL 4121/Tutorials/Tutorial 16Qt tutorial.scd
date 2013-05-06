s.makeWindow.boot;

GUI.qt;


/*
TUTORIAL 14 - GUI

Graphical User Interfaces

Often it is easier to control aspects of a patch with buttons and sliders rather than using
command line instructions. SuperCollider offers some very powerful (and
sometimes
confusing) GUI building tools.

To view a pallette of buttons and sliders, type:

shift cmd N

You can drag and drop objects into the construction window, click the ->Code button and then
execute that code. You will then have a template that does nothing... It is complicated linking
gui elements to your SynthDefs so let's do it step by step.

The first thing we will want to do is make a window. To do this we will use SCWindow and
Rect. Rect takes the initial screen position and the window size as screenX, screenY,
windowWidth, windowHeight, where Y is 0 at the bottom.

Run this code sveral times and change the numbers to wee what happens. Note that we
count on the y axis from screen origin at bottom left, to the bottom left corner of the window.

*/
s.boot;
{SinOsc.ar()}.play;
(
w = Window("My Window", Rect(120, 280, 440, 360));
w.front; // make window visible and front window.
)

/*
We can add properties to our window, such as color.
*/

w.view.background = Color.rand;
w.view.background = Color.rand;
w.view.background = Color.rand;

//Animate your window

(
Routine({
	30.do {
		w.view.background =
			Color.rand;
		0.25.wait;
	};
}).play(AppClock);
)

/*
Now we need to add controls to the window and define their parameters. We will use
Rect to specify where in the window it will appear and how large it will be.
*/

(
var w, slid;

w=Window("My Window", Rect(100,500,200,200));
//A 200 by 200 window appears at screen co-ordinates (100, 500)

slid=Slider(w,Rect(10,10,150,40));

slid.action_({slid.value.postln;});

w.front;
)

/*
Note how the default slider range is from 0.0 to 1.0. A ControlSpec can be used to turn
this into any desired range.
*/

(
var w, slid, cs;

w = Window("My Window", Rect(100,500,200,200));
//A 200 by 200 window appears at screen co-ordinates (100, 500)

slid=Slider(w,Rect(10,10,150,40));

//arguments minimum value, maximum value, warp (mapping function),
//stepsize, starting value
cs = ControlSpec(20, 20000, 'exp', 10, 1000);

slid.action_({cs.map(slid.value).postln;}); //map to the desired range

w.front;
)

/*
The following example makes a SynthDef instrument first and is given a symbol name filterme.
Then, a gui is built that will control the freq and rq parameters of the instrument with a
two-dimensinal slider.
*/

//make the SynthDef
(
SynthDef(\filterme,
{arg freq=1000, rq=0.5;
Out.ar(0,
Pan2.ar(
BPF.ar(Impulse.ar(LFNoise0.kr(15,500,1000),0.1, WhiteNoise.ar(2)),freq,rq)
))
}).add
)

//make the gui
(
var w, slid2d, syn;

w=Window("My Window", Rect(100,300,200,200));
slid2d= Slider2D(w,Rect(5,5,175,175));

syn=Synth(\filterme);

slid2d.action_({
[slid2d.x, slid2d.y].postln;
syn.set(\freq,100+(10000*slid2d.y),\rq,0.01+(0.09*slid2d.x));
});

w.front;

w.onClose={syn.free;};
)

/*
Now lets a build a synth that can be controlled by a GUI.
*/

(
// start server
s = Server.local;
Server.default = s;
s.boot;
)

(
// define a synth
SynthDef("window-test", { arg note = 36, fc = 1000, rq = 0.25, bal=0, amp=0.4, gate = 1;
		var x;
		x = Mix.fill(4, {
			LFSaw.ar((note + {0.1.rand2}.dup).midicps, 0, 0.02)
		});
		x = RLPF.ar(x, fc, rq).softclip;
		x = RLPF.ar(x, fc, rq, amp).softclip;
		x = Balance2.ar(x[0], x[1], bal);
		x = x * EnvGen.kr(Env.cutoff, gate, doneAction: 2);
		Out.ar(0, x);
	}, [0.1, 0.1, 0.1, 0.1, 0.1, 0]
).add;
)

(
// make the window
w = Window("another control panel", Rect(20, 400, 440, 360));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);
w.view.background = Color.rand;
)

(
// add a button to start and stop the sound.
b = Button(w, 75 @ 24);
b.states = [["Start", Color.black, Color.green],["Stop", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", "window-test", 9999, 0, 0);
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", 9999, "gate", 0);
		};
};
)

(
// add a label
w.view.decorator.nextLine;
v = StaticText(w, 80 @ 24);
v.string = "Note";
v.stringColor = Color.white;
v.align = \right;
)

v.align = \left;
v.align = \center;
v.align = \right;

(
// create a ControlSpec for mapping values to correct range.
~noteSpec = ControlSpec(24, 60, \lin, 1);
// create slider and number views.
~noteSlider = Slider(w, 200 @ 24);
~noteNumBox = NumberBox(w, 64 @ 24);

~noteSlider.step = 1/(60-24);
~noteSlider.action = {|view|
	var note;
	note = ~noteSpec.map(view.value);
	~noteNumBox.value = note;
	s.sendMsg("/n_set", 9999, "note", note);
};

~noteNumBox.action = {|view|
	var note;
	note = view.value;
	s.sendMsg("/n_set", 9999, "note", note);
	~noteSlider.value = ~noteSpec.unmap(note);
};
~noteNumBox.align = \center;
)

/*
This seems like a lot of work for a simple GUI control so a wrapper class, EZSlider, was created.
EZSlider will take care of the details for you as it is a wrapper for a SCStaticText, an SCSlider, and
an SCNumberBox along with the logic to manage them.
*/

(
// create controls.
w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Note", ControlSpec(24, 60, \lin, 1),
	{|ez| s.sendMsg("/n_set", 9999, "note", ez.value); });

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Cutoff", ControlSpec(200, 5000, \exp),
	{|ez| s.sendMsg("/n_set", 9999, "fc", ez.value); });

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Resonance", ControlSpec(0.1, 0.7),
	{|ez| s.sendMsg("/n_set", 9999, "rq", ez.value); });

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Balance", \bipolar,
	{|ez| s.sendMsg("/n_set", 9999, "bal", ez.value); });

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Amp", \db,
	{|ez| s.sendMsg("/n_set", 9999, "amp", ez.value.dbamp); });
)


/*
There are still some problems:
	• Restarting the sound doesn't remember the slider settings.
	• cmd-period doesn't change the button.
	• Closing window doesn't stop the sound.
We will need a more comprehensive approach. This next example solves these problems.

Use this as a possible model for slider GUIs
*/


(
var w, startButton, noteControl, cutoffControl, resonControl;
var balanceControl, ampControl;
var id, cmdPeriodFunc;

id = s.nextNodeID; // generate a node id.

// make the window
w = Window("another control panel", Rect(20, 400, 480, 180));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);

w.view.background = Color.rand;

// add a button to start and stop the sound.
startButton = Button(w, 75 @ 24);
startButton.states = [
	["Start", Color.black, Color.green],
	["Stop", Color.white, Color.red]
];
startButton.action = {|view|
		if (view.value == 1) {
			// start sound
			s.sendMsg("/s_new", "window-test", id, 0, 0,
				"note", noteControl.value,
				"fc", cutoffControl.value,
				"rq", resonControl.value,
				"bal", balanceControl.value,
				"amp", ampControl.value.dbamp);
		};
		if (view.value == 0) {
			// set gate to zero to cause envelope to release
			s.sendMsg("/n_set", id, "gate", 0);
		};
};

// create controls for all parameters
w.view.decorator.nextLine;
noteControl = EZSlider(w, 400 @ 24, "Note", ControlSpec(24, 60, \lin, 1),
	{|ez| s.sendMsg("/n_set", id, "note", ez.value); }, 36);

w.view.decorator.nextLine;
cutoffControl = EZSlider(w, 400 @ 24, "Cutoff", ControlSpec(200, 5000, \exp),
	{|ez| s.sendMsg("/n_set", id, "fc", ez.value); }, 1000);

w.view.decorator.nextLine;
resonControl = EZSlider(w, 400 @ 24, "Resonance", ControlSpec(0.1, 0.7),
	{|ez| s.sendMsg("/n_set", id, "rq", ez.value); }, 0.2);

w.view.decorator.nextLine;
balanceControl = EZSlider(w, 400 @ 24, "Balance", \bipolar,
	{|ez| s.sendMsg("/n_set", id, "bal", ez.value); }, 0);

w.view.decorator.nextLine;
ampControl = EZSlider(w, 400 @ 24, "Amp", \db,
	{|ez| s.sendMsg("/n_set", id, "amp", ez.value.dbamp); }, -6);


// set start button to zero upon a cmd-period
cmdPeriodFunc = { startButton.value = 0; };
CmdPeriod.add(cmdPeriodFunc);

// stop the sound when window closes and remove cmdPeriodFunc.
w.onClose = {
	s.sendMsg("/n_free", id);
	CmdPeriod.remove(cmdPeriodFunc);
};

)

/*
Here are two more examples of controlling a synth from a GUI. These are both SynthDef instruments
that are using the .write message. You will need to use the Load button on the GUI to load it into the server.
*/

// create a window to start and stop a synth

(

//make the synth

SynthDef("moto-rev", {
	var x;
	x = RLPF.ar(LFPulse.ar(SinOsc.kr(0.2, 0, 10, 21), [0,0.1], 0.1), 100, 0.1).clip2(0.4);
	Out.ar(0, x);
}).add
)
//make the gui
(
	var w, b1, b2, b3, name, a, s;
	name = "moto-rev";
	s = Server.local;
	w = Window(name.asString, Rect(128, 64, 260, 80));
	w.view.decorator = FlowLayout(w.view.bounds);

	b1 = Button(w, Rect(0,0, 80, 24));
	b1.states = [["Load", Color.black, Color.green]];
	b1.action = { arg view;
		s.sendMsg("/d_load", "synthdefs/"++name++".scsyndef");
	};
	b1.enabled = s.serverRunning;

	b2 = Button(w, Rect(0,0, 80, 24));
	b2.states = [
		["Play", Color.black, Color.green],
		["Stop", Color.white, Color.red],
	];
	b2.action = { arg view;
		if (b2.value == 1, {
			s.sendMsg("/s_new", name, 1001, 1, 0);
		},{
			s.sendMsg("/n_free", 1001);
		});
	};
	b2.enabled = s.serverRunning;

	a = SimpleController(s);
	f = { arg server;
		b1.enabled = server.serverRunning;
		b2.enabled = server.serverRunning;
	};
	a.put(\serverRunning, f);
	w.onClose = {.
		a.remove;
		s.sendMsg("/n_free", 1001);
	};
	w.front;
)

////////////////////////////////////////////////////////////////////////

// GUI to control a synth

(
SynthDef("trem", { arg freq=800, rate=8, amp=0.1;
	var osc;
	freq = Lag.kr(freq, 0.3);
	osc = LFTri.ar(freq, 0, SinOsc.kr( rate + [0,0.1],0,amp).max(0));
	Out.ar(0, osc)
}).add
)

(
var w, f, d, values, server, id, isOn = false;
var b1, b2;

values = IdentityDictionary.new;
server = Server.local;

f = { arg name, spec = \lin, guispec;
	var height = 20, v, s, n;
	guispec = guispec ? spec;
	spec = spec.asSpec;
	guispec = guispec.asSpec;

	v = StaticText(w, Rect(0, 0, 72, height));
	v.font = Font("Helvetica", 12);
	v.stringColor = Color.black;
	v.align = \right;

	s = Slider(w, Rect(0, 0, 182, height));
	s.resize = 2;
	s.action = {
		var val, guival, step;
		val = spec.map(s.value);
		values.put(name, val);
		if (isOn, { server.sendMsg("/n_set", id, name, val); });
		guival = guispec.map(s.value);
		step = pow(10, floor(min(0, guival.abs.log10 - 2)));
		v.string = guival.round(step).asString ++ guispec.units;
	};
	s.value = spec.unmap(spec.default);
	s.action.value;

	n = StaticText(w, Rect(0, 0, 72, height));	n.string = name;
	n.stringColor = Color.black;
	n.font = Font("Helvetica", 12);
	n.resize = 3;

	w.view.decorator.nextLine;
};

id = 2001;
w = Window("trem", Rect(512, 64, 360, 130));
w.view.decorator = d = FlowLayout(w.view.bounds);

b1 = Button(w, Rect(0,0, 80, 24));
b1.states = [["Load", Color.black, Color.green]];
b1.action = { arg view;
	server.sendMsg("/d_load", "synthdefs/trem.scsyndef");
};
b1.enabled = server.serverRunning;

b2 = Button(w, Rect(0,0, 80, 24));
b2.states = [
	["Play", Color.black, Color.green],
	["Stop", Color.white, Color.red],
];
b2.action = { arg view;
	var msg;
	if (view.value == 1, {
		isOn = true;
		msg = ["/s_new", "trem", 2001, 1, 0];
		values.keysValuesDo({ arg key, value;
			msg = msg.addAll([key, value]);
		});
		server.performList(\sendMsg, msg);
	},{
		isOn = false;
		server.sendMsg("/n_free", 2001);
	});
};
b2.enabled = server.serverRunning;
d.nextLine;

f.value(\freq, \freq);
f.value(\rate, \lofreq);
f.value(\amp, \amp, \db);

a = SimpleController(server);
f = { arg server;
	b1.enabled = server.serverRunning;
	b2.enabled = server.serverRunning;
	if (server.serverRunning.not, { b2.value = 0 });
};
a.put(\serverRunning, f);
w.onClose = {
	if (isOn, { server.sendMsg("/n_free", 2001) });
 	a.remove;
};

w.front;
)

/*

Here is some code to create a GUI to start and stop two
synths with volume control.

*/


(
// define first synth
SynthDef("window-test", { arg note = 36, fc = 1000, rq = 0.25, bal=0, amp=0.4, gate = 1;
		var x;
		x = Mix.fill(4, {
			LFSaw.ar((note + {0.1.rand2}.dup).midicps, 0, 0.02)
		});
		x = RLPF.ar(x, fc, rq).softclip;
		x = RLPF.ar(x, fc, rq, amp).softclip;
		x = Balance2.ar(x[0], x[1], bal);
		x = x * EnvGen.kr(Env.cutoff, gate, doneAction: 2);
		Out.ar(0, x);
	}, [0.1, 0.1, 0.1, 0.1, 0.1, 0]
).add;

// define second synth
SynthDef("window-test2", { arg note = 60, fc = 500, rq = 0.25, bal=0, amp=0.4, gate = 1;
		var x;
		x = Mix.fill(4, {
			LFSaw.ar((note + {0.1.rand2}.dup).midicps, 0, 0.02)
		});
		x = RLPF.ar(x, fc, rq).softclip;
		x = RLPF.ar(x, fc, rq, amp).softclip;
		x = Balance2.ar(x[0], x[1], bal);
		x = x * EnvGen.kr(Env.cutoff, gate, doneAction: 2);
		Out.ar(0, x);
	}, [0.1, 0.1, 0.1, 0.1, 0.1, 0]
).add;

// make the window
w = Window("dual synth control panel", Rect(20, 400, 400, 360));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);
w.view.background = Color.blue;

// add a button to start and stop the sound for synth 1.
b = Button(w, 75 @ 24);
b.states = [["Start 1", Color.black, Color.green],["Stop 1", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", "window-test", 9999, 0, 0);
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", 9999, "gate", 0);
		};
};


// create a ControlSpec for mapping values to correct range synth 1.
~noteSpec = ControlSpec(24, 60, \lin, 1);
// create slider and number views.
~noteSlider = Slider(w, 200 @ 24);
~noteNumBox = NumberBox(w, 64 @ 24);

~noteSlider.step = 1/(60-24);
~noteSlider.action = {|view|
	var note;
	note = ~noteSpec.map(view.value);
	~noteNumBox.value = note;
	s.sendMsg("/n_set", 9999, "note", note);
};

~noteNumBox.action = {|view|
	var note;
	note = view.value;
	s.sendMsg("/n_set", 9999, "note", note);
	~noteSlider.value = ~noteSpec.unmap(note);
};
~noteNumBox.align = \center;



// add a button 2 to start and stop the sound for synth 2.
b = Button(w, 75 @ 24);
b.states = [["Start 2", Color.black, Color.green],["Stop 2", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", "window-test2", 9998, 0, 0);//define node
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", 9998, "gate", 0);//define node
		};
};


// create a ControlSpec for mapping values to correct range synth 2.
~noteSpec2 = ControlSpec(60, 90, \lin, 1);
// create slider and number views.
~noteSlider2 = Slider(w, 200 @ 24);
~noteNumBox2 = NumberBox(w, 64 @ 24);

~noteSlider2.step = 1/(90-60);
~noteSlider2.action = {|view|
	var note2;
	note2 = ~noteSpec2.map(view.value);
	~noteNumBox2.value = note2;
	s.sendMsg("/n_set", 9998, "note", note2);
};

~noteNumBox2.action = {|view|
	var note2;
	note2 = view.value;
	s.sendMsg("/n_set", 9998, "note", note2);
	~noteSlider2.value = ~noteSpec2.unmap(note2);
};
~noteNumBox2.align = \center;
)

/*

The folowing patch creates knobs as comtrols. You will notice a slightly
different syntax. This alternate method creates the nodes automatically.

*/

(
// start server
s.waitForBoot({

var w, startButton, noteControl, cutoffControl, resonControl;
var balanceControl, ampControl;
var node, cmdPeriodFunc;

// define a synth
SynthDef("window-test", { arg note = 36, fc = 1000, rq = 0.25, bal=0, amp=0.4, gate = 1;
		var x;
		x = Mix.fill(4, {
			LFSaw.ar((note + {0.1.rand2}.dup).midicps, 0, 0.02)
		});
		x = RLPF.ar(x, fc, rq).softclip;
		x = RLPF.ar(x, fc, rq, amp).softclip;
		x = Balance2.ar(x[0], x[1], bal);
		x = x * EnvGen.kr(Env.cutoff, gate, doneAction: 2);
		Out.ar(0, x);
	}, [0.1, 0.1, 0.1, 0.1, 0.1, 0]
).add;




// make the window
w = Window("another control panel", Rect(20, 400, 230, 250));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);
w.view.decorator.gap=2@2;

// add a button to start and stop the sound.
startButton = Button(w, 75 @ 20);
startButton.states = [
	["Start", Color.black, Color.green(0.7)],
	["Stop", Color.white, Color.red(0.7)]
];
startButton.action = {|view|
		if (view.value == 1) {
			// start sound
			node = Synth( "window-test", [
				"note", noteControl.value,
				"fc", cutoffControl.value,
				"rq", resonControl.value,
				"bal", balanceControl.value,
				"amp", ampControl.value.dbamp ]);
		} {
			// set gate to zero to cause envelope to release
			node.release; node = nil;
		};
};

// create controls for all parameters
w.view.decorator.nextLine;
noteControl = EZKnob(w, 220 @ 32, "Note ", ControlSpec(24, 60, \lin, 1, 36, \note),
	{|ez| node.set( "note", ez.value )}, unitWidth:30,layout:\horz)
		.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
cutoffControl = EZKnob(w, 220 @ 32, "Cutoff ", ControlSpec(200, 5000, \exp,0.01,1000,\Hz),
	{|ez| node.set( "fc", ez.value )}, unitWidth:30,layout:\horz)
		.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
resonControl = EZKnob(w, 220 @ 32, "Reson ", ControlSpec(0.1, 0.7,\lin,0.001,0.2,\rq),
	{|ez| node.set( "rq", ez.value )}, unitWidth:30,layout:\horz)
		.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
balanceControl = EZKnob(w, 220 @ 32, "Balance ", \bipolar,
	{|ez| node.set( "bal", ez.value )},  unitWidth:30,layout:\horz)
		.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
ampControl = EZKnob(w, 220 @ 32, "Amp ", \db,
	{|ez| node.set( "amp", ez.value.dbamp )}, -6, unitWidth:30,layout:\horz)
		.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);


// set start button to zero upon a cmd-period
cmdPeriodFunc = { startButton.value = 0; };
CmdPeriod.add(cmdPeriodFunc);

// stop the sound when window closes and remove cmdPeriodFunc.
w.onClose = {
	node.free; node = nil;
	CmdPeriod.remove(cmdPeriodFunc);
};
});
)


/*
Here are some more non-sounding examples.

*/


(
// create a GUI window with some SCPopUpMenus.
var w, n, f, s, a;
w = Window("popup menu test", Rect(128, 64, 260, 110));
w.view.decorator = f = FlowLayout(w.view.bounds);
a = ["linear", \exponential, "very long item name", \sine, "welch", "curve -2", "db fader", "squared", "cubed"];

n = PopUpMenu(w, Rect(0,0,80,18));
n.items = a;

n = PopUpMenu(w, Rect(0,0,80,18));
n.items = a;

n = PopUpMenu(w, Rect(0,0,80,18));
n.items = a;

f.nextLine;

n = PopUpMenu(w, Rect(0,0,80,18));
n.items = a;
n.value = 5;

n = PopUpMenu(w, Rect(0,0,80,18));
n.items = a;
n.background = Color.red;

n = PopUpMenu(w, Rect(0,0,80,18));
n.items = a;
n.background = Color.blue;
n.stringColor = Color.white;
n.value = 3;
n.action = { arg view; view.value.postln; };

f.nextLine;

s = Slider(w, Rect(0,0,240,24));

w.front;
)


////////////////////////////////////////////////////////////////////////

(
// create a GUI for a mixer.
var w;

w = Window("mixer", Rect(128, 64, 340, 360));
w.view.decorator = f = FlowLayout(w.view.bounds,Point(4,4),Point(4,2));
17.do({ arg i;
	var v, s, n, spec, p, height = 16;

	v = StaticText(w, Rect(0, 0, 56, height+2));
	if (i == 0, {
		v.font = Font("Helvetica-Bold", 13);
		v.stringColor = Color.yellow;
	},{
		v.font = Font("Helvetica", 12);
		v.stringColor = Color.white;
	});
	v.align = \right;
	s = Slider(w, Rect(0, 0, 182, height));
	s.resize = 2;
	spec = \db.asSpec;
	s.action = {
		var db;
		db = spec.map(s.value).round(0.1);
		//v.string = if (db < -100, { "-inf" },{ db.asString ++ " dB" });
		v.string = db.asString ++ " dB" ;
	};
	s.action.value;

	n = StaticText(w, Rect(0, 0, 72, height+2));
	if (i == 0, {
		n.string = "Master";
		n.stringColor = Color.yellow;
		n.font = Font("Helvetica-Bold", 13);
	},{
		n.string = "Channel " ++ i;
		n.stringColor = Color.white;
		n.font = Font("Helvetica", 12);
	});
	n.background = Color.rand(0.1,0.5);
	n.resize = 3;

	f.nextLine;
});
w.view.background = Color.green;
w.front;
w.refresh;
)

/*

Here is an example of using a slider to control tempo. The SynthDef is based
on the Karplus/Strong plucked string model. Notice the arguments in the SynthDef. delayDecay
will control the tempo and gate will allow the Stop button in the GUI to cease playback. The
gate arg will be linked to the Start/Stop button and the  delayDecay will be linked to the slider.

*/

///////string model with GUI tempo control


s = Server.internal; s.boot;

//make the SynthDef

(
SynthDef("GUItest",
{
    arg delayDecay = 2, gate = 1;
	var burstEnv, pitchArray, delayTime, att = 0, dec = 0.001;
	var out;
	pitchArray = [52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
					52, 59, 52, 60, 62, 64].midicps.reciprocal;
	 delayTime = Select.kr(
			Stepper.kr(Impulse.kr(delayDecay), max: pitchArray.size-1),
			pitchArray);
	burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(delayDecay));
	out = BrownNoise.ar(burstEnv)+PinkNoise.ar(burstEnv*2);
	out = out + CombL.ar(
		out,
		delayTime,
		delayTime,
		delayDecay); //Echo chamber
		x = Out.ar([0,1],
			Pan2.ar(
					out, 0));
	    x = x * EnvGen.kr(Env.cutoff, gate, doneAction: 2)
}).add;
 )

//Make the GUI

(
var w, startButton, delayDecay;

var id, cmdPeriodFunc;

id = s.nextNodeID; // generate a node id.

// make the window
w = Window("String Model Tempo Control", Rect(20, 400, 440, 180));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);

w.view.background = Color.white;

// add a button to start and stop the sound.
startButton = Button(w, 75 @ 24);
startButton.states = [
	["Start", Color.black, Color.green],
	["Stop", Color.white, Color.red]
];
startButton.action = {|view|
		if (view.value == 1) {
			// start sound
			s.sendMsg("/s_new", "GUItest", id, 0, 0,
				"Tempo", delayDecay.value);
		};
		if (view.value == 0) {
			// set gate to zero to cause envelope to release
			s.sendMsg("/n_set", id, "gate", 0);
		};
};

// create controls for all parameters
w.view.decorator.nextLine;
delayDecay = EZSlider(w, 400 @ 24, "Tempo", ControlSpec(2, 20, \lin, 1),
	{|ez| s.sendMsg("/n_set", id, "delayDecay", ez.value); }, 2);


// set start button to zero upon a cmd-period
cmdPeriodFunc = { startButton.value = 0; };
CmdPeriod.add(cmdPeriodFunc);

// stop the sound when window closes and remove cmdPeriodFunc.
w.onClose = {
	s.sendMsg("/n_free", id);
	CmdPeriod.remove(cmdPeriodFunc);
};

)


/*

This is a piece I composed for BLOrk, interactice video, and dncers.



Garden Light - for BLOrk
								- John Drumheller 2011

Boot your servers.

Set the localhost server volume to 0.

Evaluate the code by double clicking after the
first open prentheses to select the block of text.

Type the ENTER key. [fn - return or shift - return]

Use the start button to begin the piece.

Everyone start in unison and then leave the dance area.

The reverb should be fine.
(I put the reverb controls in the patch just in case the gig was in a
really dry Holliday Inn lounge.)

*/
s.boot;
( // double click after this parens
s.waitForBoot({

var w, startButton, volumeControl, mixControl, roomSizeControl;
var dampControl, node, cmdPeriodFunc;

SynthDef("gardenPluck1",
{
	arg amp = 0, mix = 0.8, room = 0.7, damp = 0, gate = 1;
	e = Env.new(
				[0.1, 0.1, 3, 0.5, 8, 8, 0.1, 0.1, 144, 377+13, 0.001, 0],
				[34, 55, 21, 55, 34, 8, 13, 34, 8, 34, 8]*1.3,
				[0, 3, -4, 6, 8, 0, 0, 9, 0]
				);

	n = 8; // 2 if 6 BLOrks
	x = Mix.ar(
		CombL.ar(
				Dust.ar(
					EnvGen.kr(e, doneAction: 2).dup(n)
				),
				0.01,
				{0.005.rand+0.0003}.dup(n),
				8,
				amp
			);
		);
	y = LeakDC.ar(x);
	z = FreeVerb.ar(y, mix, room, damp, amp); //amp*2
	z = z * EnvGen.kr(Env.cutoff, gate, doneAction: 2);
	Out.ar([0,1,3,4,5], z)
}).add;


// make the window
w = Window("Garden Light - BLOrk", Rect(600, 400, 377, 610));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);
w.view.decorator.gap=2@2;

w.drawFunc = {
			// set the Color
			Pen.strokeColor = Color.gray;
			Pen.moveTo(300@30);
			Pen.lineTo(300@400);
			Pen.lineTo(30@400);
			Pen.stroke
		};


v = StaticText(w, 480 @ 24);
v.string = "START WITH CUE";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

// add a button to start and stop the sound.
startButton = Button(w, 89 @ 34);
startButton.states = [
	["Start", Color.black, Color.green(0.7)],
	["Stop", Color.white, Color.red(0.7)]
];
startButton.action = {|view|
		if (view.value == 1) {
			// start sound
			node = Synth( "gardenPluck1", [
				"amp", volumeControl.value.dbamp,
				"mix", mixControl.value,
				"room", roomSizeControl.value,
				"damp", dampControl.value ]);


		} {
			// set gate to zero to cause envelope to release
			node.release; node = nil;
		};
};


v = StaticText(w, 480 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

v = StaticText(w, 480 @ 24);
v.string = "VOLUME CONTROL";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

// create controls for all parameters
w.view.decorator.nextLine;
volumeControl = EZKnob(w, 233 @ 55, "Volume ", \db,
	{|ez| node.set( "amp", ez.value.dbamp )}, 0, unitWidth:30,layout:\horz)
		.setColors(Color.grey,Color.white, Color.grey(0.9),Color.black, Color.white, Color.yellow);

v = StaticText(w, 480 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

v = StaticText(w, 480 @ 24);
v.string = "REVERB ADJUSTMENT";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

w.view.decorator.nextLine;
mixControl = EZKnob(w, 220 @ 32, "Mix ", ControlSpec(0, 1, \lin, 0.01, 0.8),
	{|ez| node.set( "mix", ez.value )}, unitWidth:30,layout:\horz)
		.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
roomSizeControl = EZKnob(w, 220 @ 32, "RoomSize ", ControlSpec(0, 1, \lin,0.01,0.7),
	{|ez| node.set( "room", ez.value )}, unitWidth:30,layout:\horz)
		.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
dampControl = EZKnob(w, 220 @ 32, "Damp ", ControlSpec(0, 1,\lin,0.001, 0.5),
	{|ez| node.set( "damp", ez.value )}, unitWidth:30,layout:\horz)
		.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

// set start button to zero upon a cmd-period
cmdPeriodFunc = { startButton.value = 0; };
CmdPeriod.add(cmdPeriodFunc);

// stop the sound when window closes and remove cmdPeriodFunc.
w.onClose = {
	node.free; node = nil;
	CmdPeriod.remove(cmdPeriodFunc);
};
})
)






