/*
How to build a delay and effects box

Start with basic patch. This will poll Mouse positions for
delay time (x) and ring modulation (y).
*/
s.boot;
(
{
var in;

in = SoundIn.ar(0, 1.4) * SinOsc.ar(MouseY.kr(0, 1260).poll(1), [0,0.5pi]);

		a = CombL.ar(
			in,
			6.0, 				// max delay time
			MouseX.kr(0, 6.0).poll(1),    // delay time
			20,				// echo 60 dB decay time in seconds
			5 				// scale by unity
		);
		x = FreeVerb.ar(a, 0.5, 0.5, 0.5, 0.3);
		//Out.ar([0, 1], x)
}.play
)


//make the patch into a SynthDef

(
SynthDef("fxUnit",
{
arg maxdelay = 1, delay = 1, decay = 1, scale = 1, ringMod = 1,
	mix = 0.5, room = 0.5, damp = 0.5, vol = 0.5;
var in, delayunit, reverb;

in = SoundIn.ar(0, 1.4) * SinOsc.ar(ringMod, [0,0.5pi]);

		delayunit = CombL.ar(
			in,
			maxdelay, 				// max delay time
			delay,    // delay time
			decay,				// echo 60 dB decay time in seconds
			scale				// scale by unity

		);
		reverb = FreeVerb.ar(
		   delayunit,
			mix,
			room,
			damp,
			vol
		);
		Out.ar([0, 1], reverb)
}).add
)

a = Synth("fxUnit", [\delay, 1, \decay, 1, \ringMod, 1]);
a.set(\delay, 2, \decay, 8, \ringMod, 260);
a.free;

//add gate arg & env cutoff and make gui controls

(
SynthDef("fxUnit2",
{
arg maxdelay = 0.1, delay = 0.1, decay = 0.1, scale = 1, ringMod = 1,
	mix = 0.5, room = 0.5, damp = 0.5, vol = 0.5, gate = 1;

var in, delayunit, reverb;

in = SoundIn.ar(0, 1.4) * SinOsc.ar(ringMod, [0,0.5pi]);
	delayunit = CombL.ar(
			in,
			maxdelay, 				// max delay time
			delay,    // delay time
			decay,				// echo 60 dB decay time in seconds
			scale				// scale by unity
		);
		reverb = FreeVerb.ar(
		   delayunit,
			mix,
			room,
			damp,
			vol
		);
		reverb = reverb * EnvGen.kr(Env.cutoff, gate, doneAction: 2); //env cutoff - stop button
		Out.ar([0, 1], reverb)
}).add;

// put it in a gui

w = Window("Cheapo FX Box", Rect(600, 400, 440, 520));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);
w.view.decorator.gap=2@2;

// add a button to start and stop the sound.
b = Button(w, 75 @ 24);
b.states = [["Start", Color.black, Color.green],["Stop", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", "fxUnit2", 9998, 0, 0);
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", 9998, "gate", 0);
		};
};

v = StaticText(w, 480 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

w.view.decorator.nextLine;
v = EZKnob(w, 233 @ 55, "Volume ", \db,
	{|ez| s.sendMsg("/n_set", 9998, "vol", ez.value.dbamp)}, -6, unitWidth:30,layout:\horz)
		.setColors(Color.grey,Color.white, Color.grey(0.9),Color.black, Color.white, Color.yellow);

v = StaticText(w, 480 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

v = StaticText(w, 480 @ 24);
v.string = "Ring Modulation";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Ring Mod", ControlSpec(0, 1260),
	{|ez| s.sendMsg("/n_set", 9998, "ringMod", ez.value); });

v = StaticText(w, 480 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

v = StaticText(w, 480 @ 24);
v.string = "Delay Unit";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);


w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Max Delay", ControlSpec(0, 8),
	{|ez| s.sendMsg("/n_set", 9998, "maxdelay", ez.value); });

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Delay", ControlSpec(0, 8),
	{|ez| s.sendMsg("/n_set", 9998, "delay", ez.value); });

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Decay", ControlSpec(0, 24),
	{|ez| s.sendMsg("/n_set", 9998, "decay", ez.value); });

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Scale", ControlSpec(1, 8),
	{|ez| s.sendMsg("/n_set", 9998, "scale", ez.value); });

v = StaticText(w, 480 @ 24);
v.string = "";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

v = StaticText(w, 480 @ 24);
v.string = "Reverb Unit";
v.stringColor = Color.white;
v.align = \left;
v.font = Font("Monaco", 14);

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Mix", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9998, "mix", ez.value); });

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Room", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9998, "room", ez.value); });

w.view.decorator.nextLine;
v = EZSlider(w, 400 @ 24, "Damp", ControlSpec(0, 1),
	{|ez| s.sendMsg("/n_set", 9998, "damp", ez.value); });

)