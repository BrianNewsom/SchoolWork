//Brian Newsom
//Final Project
/*
Idea: Drum machine with GUI, including snare, kick, cymbals, hi-hat, pitched toms
Parameters: Time signature, adjustable tempo
Randomly generated beats?

How do I sync them up in time within a routine?  Make it wait before it starts til the next measure starts?
s.boot;

Due monday 1:30
Wants all source code
Sync with visual shtuff. Not.
*/
(
// define a synth
SynthDef("snare", {
		arg outBus=0, amp=0.8;
		var env0, env1, env2, env1m, oscs, noise, out;

		env0 = EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.03, 0.10], [-4, -2, -4]));
		env1 = EnvGen.ar(Env.new([110, 60, 49], [0.005, 0.1], [-4, -5]));
		env1m = env1.midicps;
		env2 = EnvGen.ar(Env.new([1, 0.4, 0], [0.05, 0.13], [-2, -2]), doneAction:2);

		oscs = LFPulse.ar(env1m, 0, 0.5, 1, -0.5) + LFPulse.ar(env1m * 1.6, 0, 0.5, 0.5, -0.25);
		oscs = LPF.ar(oscs, env1m*1.2, env0);
		oscs = oscs + SinOsc.ar(env1m, 0.8, env0);

		noise = WhiteNoise.ar(0.2);
		noise = HPF.ar(noise, 200, 2);
		noise = BPF.ar(noise, 6900, 0.6, 3) + noise;
		noise = noise * env2;

		out = oscs + noise;
		out = out.clip2(1) * amp;

		Out.ar(outBus, out.dup);
	}).send(s);

SynthDef("kick", {
		arg outBus=0;
		var env0, env1, env1m, out;

		env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.26], [-4, -2, -4]), doneAction:2);
		env1 = EnvGen.ar(Env.new([110, 59, 29], [0.005, 0.29], [-4, -5]));
		env1m = env1.midicps;

		out = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
		out = out + WhiteNoise.ar(1);
		out = LPF.ar(out, env1m*1.5, env0);
		out = out + SinOsc.ar(env1m, 0.5, env0);

		out = out * 1.2;
		out = out.clip2(1);

		Out.ar(outBus, out.dup);
	}).send(s);

SynthDef("hhclosed", {
		arg outBus=0, amp=0.3;
		var env1, env2, out, oscs1, noise, n, n2;

		n = 5;
		thisThread.randSeed = 4;

		env1 = EnvGen.ar(Env.new([0, 1.0, 0], [0.001, 0.2], [0, -12]));
		env2 = EnvGen.ar(Env.new([0, 1.0, 0.05, 0], [0.002, 0.05, 0.03], [0, -4, -4]), doneAction:2);

		oscs1 = Mix.fill(n, {|i|
			SinOsc.ar(
				( i.linlin(0, n-1, 42, 74) + rand2(4.0) ).midicps,
				SinOsc.ar( (i.linlin(0, n-1, 78, 80) + rand2(4.0) ).midicps, 0.0, 12),
				1/n
			)
		});

		oscs1 = BHiPass.ar(oscs1, 1000, 2, env1);
		n2 = 8;
		noise = WhiteNoise.ar;
		noise = Mix.fill(n2, {|i|
			var freq;
			freq = (i.linlin(0, n-1, 40, 50) + rand2(4.0) ).midicps.reciprocal;
			CombN.ar(noise, 0.04, freq, 0.1)
		}) * (1/n) + noise;
		noise = BPF.ar(noise, 6000, 0.9, 0.5, noise);
		noise = BLowShelf.ar(noise, 3000, 0.5, -6);
		noise = BHiPass.ar(noise, 1000, 1.5, env2);

		out = noise + oscs1;
		out = out.softclip;
		out = out * amp;

		Out.ar(outBus, out.dup);
	}).send(s);
)
b = Synth("snare")
c = Synth("kick")
d = Synth("hhclosed");
b.play;
s.boot;
,(
a = Routine.new({ 1.yield; 2.yield;});
//{SinOsc.ar()}.play;
if (a.next!=nil){

};
if (a.next!=nil){
	{SinOsc.ar(60.midicps())}.play;
};
if (a.next!=nil){
	{SinOsc.ar(67.midicps())}.play;
};
a.next.postln;
)
x=1;
//How do i send a message from the button?

(
var s1,s125,s15,s175,s2,s225,s25,s275,s3, s325,s35,s375,s4,s425,s45,s475;

//Make more efficient by doing
//s1 = Routine{
//blah = if(s1bool, b = Synth("snare"), (x*.25).wait)
//



x = 1
(
~snare = Routine { arg inval;
	loop {
		if(~sbool1, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool125, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool15, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool175, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool2, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool225, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool25, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool275, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool3, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool325, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool35, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool375, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool4, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool425, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool45, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~sbool475, {b=Synth("snare");}, {"FALSE".postln;});
		(x*0.25).wait;
	}
}.play;

~kick = Routine { arg inval;
	loop {
		if(~kbool1, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool125, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool15, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool175, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool2, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool225, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool25, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool275, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool3, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool325, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool35, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool375, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool4, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool425, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool45, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~kbool475, {b=Synth("kick");}, {"FALSE".postln;});
		(x*0.25).wait;
	}
}.play;

~hhclosed = Routine { arg inval;
	loop {
		if(~hhcbool1, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool125, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool15, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool175, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool2, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool225, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool25, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool275, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool3, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool325, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool35, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool375, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool4, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool425, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool45, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
		if(~hhcbool475, {b=Synth("hhclosed");}, {"FALSE".postln;});
		(x*0.25).wait;
	}
}.play;



)

(
//Set all bools false
~sbool1 = false;
~sbool125 = false;
~sbool15 = false;
~sbool175 = false;
~sbool2 = false;
~sbool225 = false;
~sbool25 = false;
~sbool275 = false;
~sbool3 = false;
~sbool325 = false;
~sbool35 = false;
~sbool375 = false;
~sbool4 = false;
~sbool425 = false;
~sbool45 = false;
~sbool475 = false;

~kbool1 = false;
~kbool125 = false;
~kbool15 = false;
~kbool175 = false;
~kbool2 = false;
~kbool225 = false;
~kbool25 = false;
~kbool275 = false;
~kbool3 = false;
~kbool325 = false;
~kbool35 = false;
~kbool375 = false;
~kbool4 = false;
~kbool425 = false;
~kbool45 = false;
~kbool475 = false;

~hhcbool1 = false;
~hhcbool125 = false;
~hhcbool15 = false;
~hhcbool175 = false;
~hhcbool2 = false;
~hhcbool225 = false;
~hhcbool25 = false;
~hhcbool275 = false;
~hhcbool3 = false;
~hhcbool325 = false;
~hhcbool35 = false;
~hhcbool375 = false;
~hhcbool4 = false;
~hhcbool425 = false;
~hhcbool45 = false;
~hhcbool475 = false;

)






w = Window.new("GUI Introduction", Rect(200,200,255,100));
b = Button.new(w,Rect(10,0,80,30)).states_([["Hide"],["Show"]]);
s = Slider.new(w,Rect(95,0,150,30));
c = CompositeView.new(w,Rect(20,35,100,60));
StaticText.new(c,Rect(0,0,80,30)).string_("Hello");
StaticText.new(c,Rect(20,30,80,30)).string_("World!");
b.action = { c.visible = b.value.asBoolean.not };
s.action = { c.bounds = Rect( s.value * 150 + 20, 35, 100, 100 ) };
w.front;

(//KICK
w = Window.new("Kick",Rect(0,400,200,200), false);


b = Button(w, Rect(20, 20, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool1 = true;},{~kbool1 = false;});
});

b = Button(w, Rect(60, 20, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool125 = true;},{~kbool125 = false;});
});

b = Button(w, Rect(100, 20, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool15 = true;},{~kbool15 = false;});
});

b = Button(w, Rect(140, 20, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool175 = true;},{~kbool175 = false;});
});

b = Button(w, Rect(20, 60, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool2 = true;},{~kbool2 = false;});
});

b = Button(w, Rect(60, 60, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool225 = true;},{~kbool225 = false;});
});

b = Button(w, Rect(100, 60, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool25 = true;},{~kbool25 = false;});
});

b = Button(w, Rect(140, 60, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool275 = true;},{~kbool275 = false;});
});

b = Button(w, Rect(20, 100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool3 = true;},{~kbool3 = false;});
});

b = Button(w, Rect(60,100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool325 = true;},{~kbool325 = false;});
});

b = Button(w, Rect(100, 100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool35 = true;},{~kbool35 = false;});
});

b = Button(w, Rect(140, 100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool375 = true;},{~kbool375 = false;});
});

b = Button(w, Rect(20, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool4 = true;},{~kbool4 = false;});
});

b = Button(w, Rect(60, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool425 = true;},{~kbool425 = false;});
});

b = Button(w, Rect(100, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool45 = true;},{~kbool45 = false;});
});

b = Button(w, Rect(140, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool475 = true;},{~kbool475 = false;});
});


w.front;
)

(//HH CLOSED
w = Window.new("Closed Hi-Hat", Rect(200,400,300,300),false);

b = Button(w, Rect(20, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool1 = true;},{~hhcbool1 = false;});
});

b = Button(w, Rect(90, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool125 = true;},{~hhcbool125 = false;});
});

b = Button(w, Rect(160, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool15 = true;},{~hhcbool15 = false;});
});

b = Button(w, Rect(230, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool175 = true;},{~hhcbool175 = false;});
});

b = Button(w, Rect(20, 60, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool2 = true;},{~hhcbool2 = false;});
});

b = Button(w, Rect(90, 60, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool225 = true;},{~hhcbool225 = false;});
});

b = Button(w, Rect(160, 60, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool25 = true;},{~hhcbool25 = false;});
});

b = Button(w, Rect(140, 60, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool275 = true;},{~hhcbool275 = false;});
});

b = Button(w, Rect(20, 100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool3 = true;},{~hhcbool3 = false;});
});

b = Button(w, Rect(60,100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool325 = true;},{~hhcbool325 = false;});
});

b = Button(w, Rect(100, 100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool35 = true;},{~hhcbool35 = false;});
});

b = Button(w, Rect(140, 100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool375 = true;},{~hhcbool375 = false;});
});

b = Button(w, Rect(20, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool4 = true;},{~hhcbool4 = false;});
});

b = Button(w, Rect(60, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool425 = true;},{~hhcbool425 = false;});
});

b = Button(w, Rect(100, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool45 = true;},{~hhcbool45 = false;});
});

b = Button(w, Rect(140, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool475 = true;},{~hhcbool475 = false;});
});

w.front;
)


(//SNARE
w = Window.new("Snare Drum", Rect(0,700,200,200), false);

b = Button(w, Rect(20, 20, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool1 = true;},{~sbool1 = false;});
});

b = Button(w, Rect(60, 20, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool125 = true;},{~sbool125 = false;});
});

b = Button(w, Rect(100, 20, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool15 = true;},{~sbool15 = false;});
});

b = Button(w, Rect(140, 20, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool175 = true;},{~sbool175 = false;});
});

b = Button(w, Rect(20, 60, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool2 = true;},{~sbool2 = false;});
});

b = Button(w, Rect(60, 60, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool225 = true;},{~sbool225 = false;});
});

b = Button(w, Rect(100, 60, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool25 = true;},{~sbool25 = false;});
});

b = Button(w, Rect(140, 60, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool275 = true;},{~sbool275 = false;});
});

b = Button(w, Rect(20, 100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool3 = true;},{~sbool3 = false;});
});

b = Button(w, Rect(60,100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool325 = true;},{~sbool325 = false;});
});

b = Button(w, Rect(100, 100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool35 = true;},{~sbool35 = false;});
});

b = Button(w, Rect(140, 100, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool375 = true;},{~sbool375 = false;});
});

b = Button(w, Rect(20, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool4 = true;},{~sbool4 = false;});
});

b = Button(w, Rect(60, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool425 = true;},{~sbool425 = false;});
});

b = Button(w, Rect(100, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool45 = true;},{~sbool45 = false;});
});

b = Button(w, Rect(140, 140, 40, 40))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool475 = true;},{~sbool475 = false;});
});

w.front;
)

r.play;
x = 1

(
// make the window
w = Window("another control panel", Rect(20, 400, 440, 360));
w.front; // make window visible and front window.
w.view.decorator = FlowLayout(w.view.bounds);
w.view.background = Color.rand;
)

(
// add a button to start and stop the sound.
var b = Button(w, 75 @ 75);
b.states = [["Start", Color.black, Color.green],["Stop", Color.white, Color.red]];
b.action = {|view|
		if (view.value == 1) {
			s.sendMsg("/s_new", r.play, 9999, 0, 0);
		};
		if (view.value == 0) {
			s.sendMsg("/n_set", r.stop, 9999, 0, 0);
		};
};
)




	loop {

		// thisThread refers to the routine.
		//postf("beats: % seconds: % time: % \n",
			//thisThread.beats, thisThread.seconds, Main.elapsedTime
		//);
		b = Synth("snare");
		x*4.wait;
	};
}.play;
/*
~s125 = Routine { arg inval;
	loop {
		(0.25*x).wait;
		if(~sbool125, {b=Synth("snare");}, {"FALSE".postln;});
		(4*x-0.25*x).wait;
	}
}.play;
~sbool125 = false;
~sbool125 = true;

~s15 = Routine { arg inval;
	loop {
		(0.5*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-0.5*x).wait;
	}
}.play;

~s175 = Routine { arg inval;
	loop {
		(0.75*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-0.75*x).wait;
	}
}.play;

~s2 = Routine { arg inval;
	loop {
		x.wait;
		//if(pressed)
		b=Synth("snare");
		(3*x).wait;
	}
}.play;

~s225 = Routine { arg inval;
	loop {
		(1.25*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-1.25*x).wait;
	}
}.play;

~s25 = Routine { arg inval;
	loop {
		(1.5*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-1.5*x).wait;
	}
}.play;

~s275 = Routine { arg inval;
	loop {

		(1.75*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-1.75*x).wait;
	}
}.play;

~s3 = Routine { arg inval;
	loop {

		(2*x).wait;
		//if(pressed)
		b=Synth("snare");
		(2*x).wait;
	}
}.play;

~s325 = Routine { arg inval;
	loop {

		(2.25*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-2.25*x).wait;
	}
}.play;

~s35 = Routine { arg inval;
	loop {

		(2.5*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-2.5*x).wait;
	}
}.play;

~s375 = Routine { arg inval;
	loop {

		(2.75*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-2.75*x).wait;
	}
}.play;

~s4 = Routine { arg inval;
	loop {

		(3*x).wait;
		//if(pressed)
		b=Synth("snare");
		(x).wait;
	}
}.play;

~s425 = Routine { arg inval;
	loop {

		(3.25*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-3.25*x).wait;
	}
}.play;

~s45 = Routine { arg inval;
	loop {
		(3.5*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-3.5*x).wait;
	}
}.play;

~s475 = Routine { arg inval;
	loop {
		(3.75*x).wait;
		//if(pressed)
		b=Synth("snare");
		(4*x-3.75*x).wait;
	}
}.play;
)
*/