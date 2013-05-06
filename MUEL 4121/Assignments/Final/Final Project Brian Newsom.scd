//Brian Newsom
//Final Project
/*
Idea: Drum machine with GUI, including snare, kick, cymbals, hi-hat, pitched toms
s.boot;

Due monday 1:30
Future Suggestions: Time signature variability, taking in audio and sequencing, some way of sequencing with pitch for instrumental stuff.
Add better preset beats
*/
w.close;

(
var w, slid,q,x,y,z;

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
	}).add;

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
	}).add;

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
	}).add;

SynthDef("hhopen", {//This sounds like straight garbage.

    var hatosc, hatenv, hatnoise, hatoutput;

    hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};

    hatosc = {HPF.ar(hatnoise,1500)};
    hatenv = {Line.ar(2, 0, 0.3)};

    hatoutput = (hatosc * hatenv);

    Out.ar(0,
    Pan2.ar(hatoutput, 0)
    )

}).add;

SynthDef(\ftom, {//So does this.

 var env4 = 0, tom = 0, tomOut = 0;

 env4 = EnvGen.kr(Env.perc(0.001, 0.3, 2, -5), 1, doneAction:2);

 tom = SinOsc.ar(80);
 tomOut = Pan2.ar(tom*env4, 0);



 Out.ar(0, tomOut);

 }).store;
//a = Synth("ftom")

~loadGUI = {
q=Window("Control Window", Rect(1200,580,200,200));
//A 200 by 200 window appears at screen co-ordinates (100, 500)

slid=Slider(q,Rect(10,10,40,150));
c = ControlSpec(2, 0.25, \exponential, -0.02); // min, max, mapping, step
slid.action_({x = (c.map(slid.value))});

b = Button(q, Rect(150, 20, 40, 40))
        .states_([
	["Rock", Color.black, Color.red],
//	["Rock Off", Color.white, Color.black]
])
.action_({arg butt;
	~rock.value;
});

f = Button(q, Rect(150, 70, 40, 40))
        .states_([
	["Shuffle", Color.black, Color.red],
//	["Rock Off", Color.white, Color.black]
])
.action_({arg butt;
	~shuffle.value;
});

d = Button(q, Rect(90,20,40,40))
.states_([["Clear", Color.black, Color.green]
	//,["Clear", Color.green, Color.black]])
])
.action_({arg butt;
	~clear.value;
});
StaticText.new(q,Rect(15,155,60,30)).string_("Tempo");

e = Button(q, Rect(90,70,40,40))
.states_([["Random", Color.black, Color.blue]
	//,["Clear", Color.green, Color.black]])
])
.action_({arg butt;
	~random.value;
});


	q.front;


//FLOOR TOM
t = Window.new("Floor Tom", Rect(350,100,320,320),false);

b = Button(t, Rect(20, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool1 = true;},{~ftbool1 = false;});
});

b = Button(t, Rect(90, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool125 = true;},{~ftbool125 = false;});
});

b = Button(t, Rect(160, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool15 = true;},{~ftbool15 = false;});
});

b = Button(t, Rect(230, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool175 = true;},{~ftbool175 = false;});
});

b = Button(t, Rect(20, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool2 = true;},{~ftbool2 = false;});
});

b = Button(t, Rect(90, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool225 = true;},{~ftbool225 = false;});
});

b = Button(t, Rect(160, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool25 = true;},{~ftbool25 = false;});
});

b = Button(t, Rect(230, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool275 = true;},{~ftbool275 = false;});
});

b = Button(t, Rect(20, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool3 = true;},{~ftbool3 = false;});
});

b = Button(t, Rect(90,160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool325 = true;},{~ftbool325 = false;});
});

b = Button(t, Rect(160, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool35 = true;},{~ftbool35 = false;});
});

b = Button(t, Rect(230, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool375 = true;},{~ftbool375 = false;});
});

b = Button(t, Rect(20, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool4 = true;},{~ftbool4 = false;});
});

b = Button(t, Rect(90, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool425 = true;},{~ftbool425 = false;});
});

b = Button(t, Rect(160, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool45 = true;},{~ftbool45 = false;});
});

b = Button(t, Rect(230, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~ftbool475 = true;},{~ftbool475 = false;});
});

t.front;


//KICK
x = Window.new("Kick Drum", Rect(0,100,320,320),false);

b = Button(x, Rect(20, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool1 = true;},{~kbool1 = false;});
});

b = Button(x, Rect(90, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool125 = true;},{~kbool125 = false;});
});

b = Button(x, Rect(160, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool15 = true;},{~kbool15 = false;});
});

b = Button(x, Rect(230, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool175 = true;},{~kbool175 = false;});
});

b = Button(x, Rect(20, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool2 = true;},{~kbool2 = false;});
});

b = Button(x, Rect(90, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool225 = true;},{~kbool225 = false;});
});

b = Button(x, Rect(160, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool25 = true;},{~kbool25 = false;});
});

b = Button(x, Rect(230, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool275 = true;},{~kbool275 = false;});
});

b = Button(x, Rect(20, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool3 = true;},{~kbool3 = false;});
});

b = Button(x, Rect(90,160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool325 = true;},{~kbool325 = false;});
});

b = Button(x, Rect(160, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool35 = true;},{~kbool35 = false;});
});

b = Button(x, Rect(230, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool375 = true;},{~kbool375 = false;});
});

b = Button(x, Rect(20, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool4 = true;},{~kbool4 = false;});
});

b = Button(x, Rect(90, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool425 = true;},{~kbool425 = false;});
});

b = Button(x, Rect(160, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool45 = true;},{~kbool45 = false;});
});

b = Button(x, Rect(230, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~kbool475 = true;},{~kbool475 = false;});
});

x.front;



//HH CLOSED
y = Window.new("Closed Hi-Hat", Rect(350,500,320,320),false);

b = Button(y, Rect(20, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool1 = true;},{~hhcbool1 = false;});
});

b = Button(y, Rect(90, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool125 = true;},{~hhcbool125 = false;});
});

b = Button(y, Rect(160, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool15 = true;},{~hhcbool15 = false;});
});

b = Button(y, Rect(230, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool175 = true;},{~hhcbool175 = false;});
});

b = Button(y, Rect(20, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool2 = true;},{~hhcbool2 = false;});
});

b = Button(y, Rect(90, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool225 = true;},{~hhcbool225 = false;});
});

b = Button(y, Rect(160, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool25 = true;},{~hhcbool25 = false;});
});

b = Button(y, Rect(230, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool275 = true;},{~hhcbool275 = false;});
});

b = Button(y, Rect(20, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool3 = true;},{~hhcbool3 = false;});
});

b = Button(y, Rect(90,160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool325 = true;},{~hhcbool325 = false;});
});

b = Button(y, Rect(160, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool35 = true;},{~hhcbool35 = false;});
});

b = Button(y, Rect(230, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool375 = true;},{~hhcbool375 = false;});
});

b = Button(y, Rect(20, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool4 = true;},{~hhcbool4 = false;});
});

b = Button(y, Rect(90, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool425 = true;},{~hhcbool425 = false;});
});

b = Button(y, Rect(160, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool45 = true;},{~hhcbool45 = false;});
});

b = Button(y, Rect(230, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhcbool475 = true;},{~hhcbool475 = false;});
});

y.front;


//HH OPEN

z = Window.new("Open Hi-Hat", Rect(700,500,320,320),false);

b = Button(z, Rect(20, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool1 = true;},{~hhobool1 = false;});
});

b = Button(z, Rect(90, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool125 = true;},{~hhobool125 = false;});
});

b = Button(z, Rect(160, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool15 = true;},{~hhobool15 = false;});
});

b = Button(z, Rect(230, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool175 = true;},{~hhobool175 = false;});
});

b = Button(z, Rect(20, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool2 = true;},{~hhobool2 = false;});
});

b = Button(z, Rect(90, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool225 = true;},{~hhobool225 = false;});
});

b = Button(z, Rect(160, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool25 = true;},{~hhobool25 = false;});
});

b = Button(z, Rect(230, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool275 = true;},{~hhobool275 = false;});
});

b = Button(z, Rect(20, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool3 = true;},{~hhobool3 = false;});
});

b = Button(z, Rect(90,160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool325 = true;},{~hhobool325 = false;});
});

b = Button(z, Rect(160, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool35 = true;},{~hhobool35 = false;});
});

b = Button(z, Rect(230, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool375 = true;},{~hhobool375 = false;});
});

b = Button(z, Rect(20, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool4 = true;},{~hhobool4 = false;});
});

b = Button(z, Rect(90, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool425 = true;},{~hhobool425 = false;});
});

b = Button(z, Rect(160, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool45 = true;},{~hhobool45 = false;});
});

b = Button(z, Rect(230, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~hhobool475 = true;},{~hhobool475 = false;});
});

z.front;




//SNARE
w = Window.new("Snare Drum", Rect(0,500,320,320),false);

b = Button(w, Rect(20, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool1 = true;},{~sbool1 = false;});
});

b = Button(w, Rect(90, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool125 = true;},{~sbool125 = false;});
});

b = Button(w, Rect(160, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool15 = true;},{~sbool15 = false;});
});

b = Button(w, Rect(230, 20, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool175 = true;},{~sbool175 = false;});
});

b = Button(w, Rect(20, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool2 = true;},{~sbool2 = false;});
});

b = Button(w, Rect(90, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool225 = true;},{~sbool225 = false;});
});

b = Button(w, Rect(160, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool25 = true;},{~sbool25 = false;});
});

b = Button(w, Rect(230, 90, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool275 = true;},{~sbool275 = false;});
});

b = Button(w, Rect(20, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool3 = true;},{~sbool3 = false;});
});

b = Button(w, Rect(90,160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool325 = true;},{~sbool325 = false;});
});

b = Button(w, Rect(160, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool35 = true;},{~sbool35 = false;});
});

b = Button(w, Rect(230, 160, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool375 = true;},{~sbool375 = false;});
});

b = Button(w, Rect(20, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool4 = true;},{~sbool4 = false;});
});

b = Button(w, Rect(90, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool425 = true;},{~sbool425 = false;});
});

b = Button(w, Rect(160, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool45 = true;},{~sbool45 = false;});
});

b = Button(w, Rect(230, 230, 70, 70))
        .states_([
            ["play", Color.black, Color.red],
            ["stop", Color.white, Color.black]
        ])
        .action_({arg butt;
	if(butt.value == 1, {~sbool475 = true;},{~sbool475 = false;});
});

w.front;
};
~loadGUI.value;


~clear;

~clear =  {
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

~ftbool1 = false;
~ftbool125 = false;
~ftbool15 = false;
~ftbool175 = false;
~ftbool2 = false;
~ftbool225 = false;
~ftbool25 = false;
~ftbool275 = false;
~ftbool3 = false;
~ftbool325 = false;
~ftbool35 = false;
~ftbool375 = false;
~ftbool4 = false;
~ftbool425 = false;
~ftbool45 = false;
~ftbool475 = false;


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

~hhobool1 = false;
~hhobool125 = false;
~hhobool15 = false;
~hhobool175 = false;
~hhobool2 = false;
~hhobool225 = false;
~hhobool25 = false;
~hhobool275 = false;
~hhobool3 = false;
~hhobool325 = false;
~hhobool35 = false;
~hhobool375 = false;
~hhobool4 = false;
~hhobool425 = false;
~hhobool45 = false;
~hhobool475 = false;
//~loadGUI.value;

};

~clear.value;
x=2;

//)

/*b = Synth("snare")
c = Synth("kick")
d = Synth("hhclosed");
e = Synth("hhopen");
*/


//How do i send a message from the button?
//* not understood means this hasn't been evaluated
//rock
//(//ROCK

~rock;

~rock = {
	~clear.value;
	~hhcbool1 = true;
	~hhcbool15 = true;
	~hhcbool2 = true;
	~hhcbool25 = true;
	~hhcbool3 = true;
	~hhcbool35 = true;
	~hhcbool4 = true;
	~hhcbool45 = true;
	~kbool1 = true;
	~kbool3 = true;
	~kbool35 = true;
	~sbool2 = true;
	~sbool4 = true;
};

~shuffle;

~shuffle = {
	~clear.value;
	~hhcbool1 = true;
	~hhcbool175 = true;
	~hhcbool2 = true;
	~hhcbool275 = true;
	~hhcbool3 = true;
	~hhcbool375 = true;
	~hhcbool4 = true;
	~hhcbool475 = true;
	~kbool1 = true;
	~kbool2 = true;
	~kbool3 = true;
	~kbool4 = true;
	~hhobool2 = true;
	~hhobool4 = true;
};
~random = {
	~sbool1 = [false,true].choose;
	~sbool125 = [false,true].choose;
	~sbool15 = [false,true].choose;
	~sbool175 = [false,true].choose;
	~sbool2 = [false,true].choose;
	~sbool225 = [false,true].choose;
	~sbool25 = [false,true].choose;
	~sbool275 = [false,true].choose;
	~sbool3 = [false,true].choose;
	~sbool325 = [false,true].choose;
	~sbool35 = [false,true].choose;
	~sbool375 = [false,true].choose;
	~sbool4 = [false,true].choose;
	~sbool425 = [false,true].choose;
	~sbool45 = [false,true].choose;
	~sbool475 = [false,true].choose;

	~ftbool1 = [false,true].choose;
	~ftbool125 = [false,true].choose;
	~ftbool15 = [false,true].choose;
	~ftbool175 = [false,true].choose;
	~ftbool2 = [false,true].choose;
	~ftbool225 = [false,true].choose;
	~ftbool25 = [false,true].choose;
	~ftbool275 = [false,true].choose;
	~ftbool3 = [false,true].choose;
	~ftbool325 = [false,true].choose;
	~ftbool35 = [false,true].choose;
	~ftbool375 = [false,true].choose;
	~ftbool4 = [false,true].choose;
	~ftbool425 = [false,true].choose;
	~ftbool45 = [false,true].choose;
	~ftbool475 = [false,true].choose;


	~kbool1 = [false,true].choose;
	~kbool125 = [false,true].choose;
	~kbool15 = [false,true].choose;
	~kbool175 = [false,true].choose;
	~kbool2 = [false,true].choose;
	~kbool225 = [false,true].choose;
	~kbool25 = [false,true].choose;
	~kbool275 = [false,true].choose;
	~kbool3 = [false,true].choose;
	~kbool325 = [false,true].choose;
	~kbool35 = [false,true].choose;
	~kbool375 = [false,true].choose;
	~kbool4 = [false,true].choose;
	~kbool425 = [false,true].choose;
	~kbool45 = [false,true].choose;
	~kbool475 = [false,true].choose;

	~hhcbool1 = [false,true].choose;
	~hhcbool125 = [false,true].choose;
	~hhcbool15 = [false,true].choose;
	~hhcbool175 = [false,true].choose;
	~hhcbool2 = [false,true].choose;
	~hhcbool225 = [false,true].choose;
	~hhcbool25 = [false,true].choose;
	~hhcbool275 = [false,true].choose;
	~hhcbool3 = [false,true].choose;
	~hhcbool325 = [false,true].choose;
	~hhcbool35 = [false,true].choose;
	~hhcbool375 = [false,true].choose;
	~hhcbool4 = [false,true].choose;
	~hhcbool425 = [false,true].choose;
	~hhcbool45 = [false,true].choose;
	~hhcbool475 = [false,true].choose;

	~hhobool1 = [false,true].choose;
	~hhobool125 = [false,true].choose;
	~hhobool15 = [false,true].choose;
	~hhobool175 = [false,true].choose;
	~hhobool2 = [false,true].choose;
	~hhobool225 = [false,true].choose;
	~hhobool25 = [false,true].choose;
	~hhobool275 = [false,true].choose;
	~hhobool3 = [false,true].choose;
	~hhobool325 = [false,true].choose;
	~hhobool35 = [false,true].choose;
	~hhobool375 = [false,true].choose;
	~hhobool4 = [false,true].choose;
	~hhobool425 = [false,true].choose;
	~hhobool45 = [false,true].choose;
	~hhobool475 = [false,true].choose;
};

//)
//~rock.value;

// RUN FUNC WITH ~rock.value;

//(
~snare = Routine { arg inval;
	loop {
		if(~sbool1, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool125, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool15, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool175, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool2, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool225, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool25, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool275, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool3, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool325, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool35, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool375, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool4, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool425, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool45, {b=Synth("snare");}, { });
		(x*0.25).wait;
		if(~sbool475, {b=Synth("snare");}, { });
		(x*0.25).wait;
	}
}.play;

~ftom = Routine { arg inval;
	loop {
		if(~ftbool1, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool125, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool15, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool175, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool2, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool225, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool25, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool275, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool3, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool325, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool35, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool375, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool4, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool425, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool45, {b=Synth("ftom");}, { });
		(x*0.25).wait;
		if(~ftbool475, {b=Synth("ftom");}, { });
		(x*0.25).wait;
	}
}.play;

~kick = Routine { arg inval;
	loop {
		if(~kbool1, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool125, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool15, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool175, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool2, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool225, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool25, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool275, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool3, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool325, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool35, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool375, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool4, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool425, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool45, {b=Synth("kick");}, { });
		(x*0.25).wait;
		if(~kbool475, {b=Synth("kick");}, { });
		(x*0.25).wait;
	}
}.play;

~hhclosed = Routine { arg inval;
	loop {
		if(~hhcbool1, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool125, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool15, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool175, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool2, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool225, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool25, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool275, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool3, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool325, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool35, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool375, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool4, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool425, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool45, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
		if(~hhcbool475, {b=Synth("hhclosed");}, { });
		(x*0.25).wait;
	}
}.play;

~hhopen = Routine { arg inval;
	loop {
		if(~hhobool1, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool125, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool15, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool175, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool2, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool225, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool25, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool275, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool3, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool325, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool35, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool375, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool4, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool425, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool45, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
		if(~hhobool475, {b=Synth("hhopen");}, { });
		(x*0.25).wait;
	}
}.play;


//)
//x = 1;
//(
//CONTROL WINDOW


)


(//RECORD TRACK
b = Buffer.alloc(s, 44100 * 0.25, 1); // 8 second mono buffer


SynthDef(\recBuf,{ arg out=0, bufnum=0;
	var in;
	in = AudioIn.ar(1);
	RecordBuf.ar(in, bufnum);
}).load(s);


SynthDef(\playBuf,{ arg out = 0, bufnum;
	var signal;
	signal = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum));
	Out.ar(out, signal ! 2)
}).load(s)


// we record into the buffer
x = Synth(\recBuf, [\out, 0, \bufnum, b.bufnum]);
x.free;
)

// and we can play it back using the playBuf synthdef we created above
z = Synth(\playBuf, [\bufnum, b.bufnum])
z.free;

~clear.value;
~random.value;
a = [true,false].choose;
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



(
var s1,s125,s15,s175,s2,s225,s25,s275,s3, s325,s35,s375,s4,s425,s45,s475;

//Make more efficient by doing
//s1 = Routine{
//blah = if(s1bool, b = Synth("snare"), (x*.25).wait)
//
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
		if(~sbool125, {b=Synth("snare");}, { });
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
