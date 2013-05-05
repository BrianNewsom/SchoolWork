(
//Type on this window
w = Window.new("c major scale");
w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;  [char, keycode].postln; };
w.front;


// then execute this and then type 'a s d f g h j k'

w.front; // something safe to type on
{ x = SinOsc.ar(60.midicps, 0, KeyState.kr(0, 0, 0.1))
+SinOsc.ar(62.midicps, 0, KeyState.kr(1, 0, 0.1))
+SinOsc.ar(64.midicps, 0, KeyState.kr(2, 0, 0.1))
+SinOsc.ar(65.midicps, 0, KeyState.kr(3, 0, 0.1))
+SinOsc.ar(67.midicps, 0, KeyState.kr(5, 0, 0.1))
+SinOsc.ar(69.midicps, 0, KeyState.kr(4, 0, 0.1))
+SinOsc.ar(71.midicps, 0, KeyState.kr(38, 0, 0.1))
+SinOsc.ar(72.midicps, 0, KeyState.kr(40, 0, 0.1))
+SinOsc.ar(74.midicps, 0, KeyState.kr(37, 0, 0.1))
+SinOsc.ar(61.midicps, 0, KeyState.kr(13, 0, 0.1))
+SinOsc.ar(63.midicps, 0, KeyState.kr(14, 0, 0.1))
+SinOsc.ar(66.midicps, 0, KeyState.kr(17, 0, 0.1))
+SinOsc.ar(68.midicps, 0, KeyState.kr(16, 0, 0.1))
+SinOsc.ar(70.midicps, 0, KeyState.kr(32, 0, 0.1))
+PMOsc.ar(40.midicps, 74.midicps, SinOsc.ar(1, 0, 5), 0, KeyState.kr(49, 0, 0.1));ASDFGHJKASFGHJK
x = FreeVerb.ar(x, 0.7,0.7,0.5);
Out.ar([1, 1], x);
}.play;
)


/*
DRONES, MODES, & COLLECTIONS
for John Gunther and BLOrk

Start the servers
Double click after the first parenthesis and then hit enter or
fn return
*/

(
SynthDef("keyboard",
{
arg amp= 0, gate = 1, mix = 0, room = 0, damp = 0, blank = 0;
var vol = 0.5;
var channels = [0,1,2,3,4,5];
x = SinOsc.ar(60.midicps, 0, KeyState.kr(0, 0, vol))
+SinOsc.ar(61.midicps, 0, KeyState.kr(13, 0, vol))
+SinOsc.ar(62.midicps, 0, KeyState.kr(1, 0, vol))
+SinOsc.ar(63.midicps, 0, KeyState.kr(14, 0, vol))
+SinOsc.ar(64.midicps, 0, KeyState.kr(2, 0, vol))
+SinOsc.ar(65.midicps, 0, KeyState.kr(3, 0, vol))
+SinOsc.ar(66.midicps, 0, KeyState.kr(17, 0, vol))
+SinOsc.ar(67.midicps, 0, KeyState.kr(5, 0, vol))
+SinOsc.ar(68.midicps, 0, KeyState.kr(16, 0, vol))
+SinOsc.ar(69.midicps, 0, KeyState.kr(4, 0, vol))
+SinOsc.ar(70.midicps, 0, KeyState.kr(32, 0, vol))
+SinOsc.ar(71.midicps, 0, KeyState.kr(38, 0, vol))
+SinOsc.ar(72.midicps, 0, KeyState.kr(40, 0, vol))
+SinOsc.ar(73.midicps, 0, KeyState.kr(31, 0, vol))
+SinOsc.ar(74.midicps, 0, KeyState.kr(37, 0, vol))
+SinOsc.ar(75.midicps, 0, KeyState.kr(35, 0, vol))
+SinOsc.ar(76.midicps, 0, KeyState.kr(41, 0, vol))
+SinOsc.ar(77.midicps, 0, KeyState.kr(39, 0, vol))

+PMOsc.ar(74.midicps, 80.midicps, 5, 0, KeyState.kr(12, 0, vol))
+PMOsc.ar(74.midicps, 82.midicps, 5, 0, KeyState.kr(15, 0, vol))
+SinOsc.ar(LFNoise0.ar(7, 450, 500), 0, KeyState.kr(34, 0, vol))
+PMOsc.ar(79.midicps, 84.midicps, SinOsc.ar(5, 0, 5), 0, KeyState.kr(33, 0, vol))
+PMOsc.ar(59.midicps, 84.midicps, SinOsc.ar(0.5, 0, 5), 0, KeyState.kr(30, 0, vol))
+PMOsc.ar(40.midicps, 74.midicps, SinOsc.ar(1, 0, 5), 0, KeyState.kr(42, 0, vol))

+SinOsc.ar(75.midicps, 0, KeyState.kr(6, 0, vol))
+SinOsc.ar(76.midicps, 0, KeyState.kr(7, 0, vol))
+SinOsc.ar(78.midicps, 0, KeyState.kr(8, 0, vol))
+SinOsc.ar(79.midicps, 0, KeyState.kr(9, 0, vol))
+SinOsc.ar(81.midicps, 0, KeyState.kr(11, 0, vol))
+SinOsc.ar(82.midicps, 0, KeyState.kr(45, 0, vol))
+SinOsc.ar(84.midicps, 0, KeyState.kr(46, 0, vol))
+SinOsc.ar(85.midicps, 0, KeyState.kr(43, 0, vol))
+SinOsc.ar(87.midicps, 0, KeyState.kr(47, 0, vol))
+SinOsc.ar(88.midicps, 0, KeyState.kr(44, 0, vol))

+SinOsc.ar(48.midicps, 0, KeyState.kr(50, 0, vol))
+SinOsc.ar(50.midicps, 0, KeyState.kr(18, 0, vol))
+SinOsc.ar(52.midicps, 0, KeyState.kr(19, 0, vol))
+SinOsc.ar(54.midicps, 0, KeyState.kr(20, 0, vol))
+SinOsc.ar(56.midicps, 0, KeyState.kr(21, 0, vol))
+SinOsc.ar(58.midicps, 0, KeyState.kr(23, 0, vol))
+SinOsc.ar(60.midicps, 0, KeyState.kr(22, 0, vol))
+SinOsc.ar(62.midicps, 0, KeyState.kr(26, 0, vol))
+SinOsc.ar(64.midicps, 0, KeyState.kr(28, 0, vol))
+SinOsc.ar(66.midicps, 0, KeyState.kr(25, 0, vol))
+SinOsc.ar(68.midicps, 0, KeyState.kr(29, 0, vol))
+SinOsc.ar(70.midicps, 0, KeyState.kr(27, 0, vol))
+SinOsc.ar(120.midicps, 0, KeyState.kr(24, 0, vol))
+PMOsc.ar(79.midicps, 84.midicps, SinOsc.ar(2, 0, 5), 0, KeyState.kr(49, 0, vol));

x = Limiter.ar(x, 1, 0.01);
x = FreeVerb.ar(x, mix, room, damp, mul:amp);
x = x * EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
Out.ar(channels ,x )
}).load(s);

SynthDef("thx",
{
arg amp1 = 0, gate1 = 1, freq = 50.0;
var channels = [0,1,2,3,4,5];
var numVoices = 30;
var fundamentals = ({rrand(200.0, 400.0)}.dup(numVoices)).sort.reverse;
var finalPitches = (numVoices.collect({arg nv; (nv/(numVoices/0.1)).round * 12; })
	+ freq);

var snd = Mix
({arg numTone;
	var freq =  finalPitches[numTone] + LFNoise2.kr(0.1, (numTone / 2));
	Pan2.ar
	(
		BLowPass.ar(Saw.ar(freq), freq * 6, 0.6),
		rrand(-0.5, 0.5),
		(1 - (1/(numTone + 1))) * 1.5 * amp1
	) / numVoices
}.dup(numVoices));

x = Limiter.ar(BLowPass.ar(snd, 20000, 0.5, 3 ))* EnvGen.kr(Env.cutoff(0.5), gate1, doneAction: 2);

Out.ar(channels, x)
}).load(s);

SynthDef("darkGen",
{
arg gate2 = 1, amp2 = 0, pos1 = 20, pos2 = 400;
var channels = [0,1,2,3,4,5];
x = GVerb.ar(CombC.ar
	(Gendy1.ar(6, 6, 3, Dust.ar([100, 101], 1), pos1, pos2),
		1, 0.01, 0.02, mul: amp2  * EnvGen.kr(Env.cutoff(0.5), gate2, doneAction: 2)),
	9, 9, mul:0.1);
	Out.ar(channels, x);
}).load(s);

SynthDef("f#78",//d74
{
arg	amp3 = 0, gate3 = 1, gfreq3 = 100, rq3 = 0.01;
var channels = [0,1,2,3,4,5];
var n, out;
n=10;

out = Resonz.ar(
Mix.fill(n,{

var freq, numcps;

freq= 74.midicps;//freq here d 74
numcps= rrand(2,20);
Pan2.ar(Gendy1.ar
	(6.rand,6.rand,1.0.rand,1.0.rand,freq ,freq, 1.0.rand, 1.0.rand, numcps,
		SinOsc.kr(exprand(0.02,0.2),
	0, numcps/2, numcps/2), 0.5/(n.sqrt)),
1.0.rand2)
}),gfreq3, rq3, amp3)* EnvGen.kr
	(Env.cutoff(0.5), gate3, doneAction: 2);//x = freq, y = rq

Out.ar(channels, out)
}).load(s);

SynthDef("b71",//g67
{
arg	amp4 = 0, gate4 = 1, gfreq4 = 100, rq4 = 0.01;
var channels = [0,1,2,3,4,5];
var n, out;
n=10;

out = Resonz.ar(
Mix.fill(n,{

var freq, numcps;

freq= 69.midicps;//freq here 67 g
numcps= rrand(2,20);
Pan2.ar(Gendy1.ar
	(6.rand,6.rand,1.0.rand,1.0.rand,freq ,freq, 1.0.rand, 1.0.rand, numcps,
		SinOsc.kr(exprand(0.02,0.2),
	0, numcps/2, numcps/2), 0.5/(n.sqrt)),
1.0.rand2)
}),gfreq4, rq4, amp4)* EnvGen.kr
	(Env.cutoff(0.5), gate4, doneAction: 2);//x = freq, y = rq

Out.ar(channels, out)
}).load(s);

SynthDef("e28",//c24
{
arg	amp5 = 0, gate5 = 1, gfreq5 = 100, rq5 = 0.01;
var channels = [0,1,2,3,4,5];
var n, out;
n=10;

out = Resonz.ar(
Mix.fill(n,{

var freq, numcps;

freq= 38.midicps;//freq here 24 c
numcps= rrand(2,20);
Pan2.ar(Gendy1.ar
	(6.rand,6.rand,1.0.rand,1.0.rand,freq ,freq, 1.0.rand, 1.0.rand, numcps,
		SinOsc.kr(exprand(0.02,0.2),
	0, numcps/2, numcps/2), 0.5/(n.sqrt)),
1.0.rand2)
}),gfreq5, rq5, amp5)* EnvGen.kr
	(Env.cutoff(0.5), gate5, doneAction: 2);//x = freq, y = rq

Out.ar(channels, out)
}).add;

////////////////

w = Window("KEYBOARD GUIDE", Rect(320, 400, 480, 1050));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);
w.view.background = w.view.background = (Color.gray);

v = StaticText(w, 480 @ 24);
v.string = "KEYBOARD MAPPING";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 24);

w.view.decorator.nextLine;
v =StaticText(w, 280 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 480 @ 24);
v.string = "~ 1 2 3... = WHOLE TONE STARTING ON C";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 380 @ 24);
v.string = "+ = VERY HIGH PITCH";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 480 @ 24);
v.string = "Q = FM, W = C#, E = D#, R = FM, T = F#";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 380 @ 24);
v.string = "Y = G#, U = A#, I = RANDOM, O = C#";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 380 @ 24);
v.string = "P = D#, { = FM, } = FM, | = LOW FM";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "ASDF... = DIATONIC";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "COLLECTION FROM C TO F";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);


v = StaticText(w, 480 @ 24);
v.string = "ZXCV... = OCTATONIC STARTING ON D#";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

v = StaticText(w, 480 @ 24);
v.string = "[0134...]";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

v = StaticText(w, 480 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

v = StaticText(w, 480 @ 24);
v.string = "WARNING:";
v.stringColor = Color.red;
v.align = \left;
v.font = Font("Monaco", 20);

v = StaticText(w, 480 @ 24);
v.string = "MOVE THE DUMMY SLIDER BEFORE TYPING";
v.stringColor = Color.red;
v.align = \left;
v.font = Font("Monaco", 16);

///////////////

w = Window("Drones, Modes, and Collections", Rect(800, 400, 480, 1050));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);
w.view.background = w.view.background = (Color.gray);


v = StaticText(w, 380 @ 24);
v.string = "KEYBOARD";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

// add a button to start and stop the sound.
w.view.decorator.nextLine;
b = Button(w, 75 @ 24);
b.states = [["Start", Color.black, Color.green],["Stop", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", "keyboard", 9999, 0, 0);
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", 9999, "gate", 0);
		};
};

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Volume", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9999, "amp", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Wet/Dry", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9999, "mix", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Room Size", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9999, "room", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "HF Damp", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9999, "damp", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Dummy", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9999, "blank", ez.value);
		};);
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);//move this slider for defaultKeyDownAction

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "THX SYNTHESIS";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
b = Button(w, 75 @ 24);
b.states = [["Start", Color.black, Color.green],["Stop", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", "thx", 9998, 0, 0);
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", 9998, "gate1", 0);
		};
};

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Volume", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9998, "amp1", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Pitch", ControlSpec(50.0, 3600, \exp, 0.01),
	{|ez| s.sendMsg("/n_set", 9998, "freq", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "DARK GENDY";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
b = Button(w, 75 @ 24);
b.states = [["Start", Color.black, Color.green],["Stop", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", "darkGen", 9997, 0, 0);
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", 9997, "gate2", 0);		};
};

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Volume", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9997, "amp2", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Position 1", ControlSpec(20, 100, \exp, 0.01),
	{|ez| s.sendMsg("/n_set", 9997, "pos1", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Position 2", ControlSpec(400, 1800, \exp, 0.01),
	{|ez| s.sendMsg("/n_set", 9997, "pos2", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "D DRONE MIDI #74";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
b = Button(w, 75 @ 24);
b.states = [["Start", Color.black, Color.green],["Stop", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", "f#78", 9996, 0, 0);
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", 9996, "gate3", 0);
		};
};

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Volume", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9996, "amp3", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Frequency", ControlSpec(100, 2000),
	{|ez| s.sendMsg("/n_set", 9996, "gfreq3", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "RQ", ControlSpec(0.01, 1.0),
	{|ez| s.sendMsg("/n_set", 9996, "rq3", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);
w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "A DRONE MIDI #69";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
b = Button(w, 75 @ 24);
b.states = [["Start", Color.black, Color.green],["Stop", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", "b71", 9995, 0, 0);
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", 9995, "gate4", 0);
		};
};

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Volume", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9995, "amp4", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);
w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Frequency", ControlSpec(100, 2000),
	{|ez| s.sendMsg("/n_set", 9995, "gfreq4", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);
w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "RQ", ControlSpec(0.01, 1.0),
	{|ez| s.sendMsg("/n_set", 9995, "rq4", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
v = StaticText(w, 280 @ 24);
v.string = "D DRONE MIDI #38";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 18);

w.view.decorator.nextLine;
b = Button(w, 75 @ 24);
b.states = [["Start", Color.black, Color.green],["Stop", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", "e28", 9994, 0, 0);
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", 9994, "gate5", 0);
		};
};

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Volume", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9994, "amp5", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Frequency", ControlSpec(100, 2000),
	{|ez| s.sendMsg("/n_set", 9994, "gfreq5", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "RQ", ControlSpec(0.01, 1.0),
	{|ez| s.sendMsg("/n_set", 9994, "rq5", ez.value);
		});
v.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);

)

