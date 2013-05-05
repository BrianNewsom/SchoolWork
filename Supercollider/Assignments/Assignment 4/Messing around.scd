//Brian Newsom
//Playing around with pattern
s.boot;
(
var melody, drums;



melody = Pbind( //fun
	\dur,1,
	\midinote, Pseq([7, 0, 4, 7, 5, 7, 4] + 60,inf),
	\amp, Prand([0.25, 0.125, 0.125, 0.2,0.125,0.2,0.125],inf)
).play;

//melody 2


//Crappy muse 7/8
	/*Pseq([
		[3810, 1], [1800, 1], [810, 0.5], [4800, 0.5],
		[3000, 1], [1700, 0.5], [810, 1], [4200, 0.5],
		[2000, 0.5], [1780, 0.5]],inf)
		).play;*/

Ppar([melody,drums ]).play(TempoClock(3));
)


//--------------------------------------------------------START-----------------------------------------------------------------------------------\\

(
SynthDef("garbageCanLid", //Play with this
{
arg dur = 1, freq = 2820;
a = PinkNoise.ar;
b = BPF.ar(a, freq, 0.2) * EnvGen.kr(Env.perc(0.0, 1, 1, -4),doneAction:2);
e = FreeVerb.ar(b, 0.5, 0.7, 0, 4);
Out.ar([0, 1], e*0.1)
}).add;
SynthDef("fender2",
{
arg midinote = 60, dur = 1, legato = 0.3;
	x = PMOsc.ar(midinote.midicps, midinote.midicps + 10, 1, 0, 0.4)
	*
	EnvGen.kr(Env.perc(0.05, 3, 1), doneAction: 2);
	x = Pan2.ar(x, 0, 0.3);
	x = FreeVerb.ar(x, 0.7, 0.9, 0.5, 0.5);
Out.ar([0, 1], x)
	}).load(s);

SynthDef("clap", { arg i_out=0, freq = 60, amp = 0.4, pan=0, gate = 1;
var out;
out = Decay2.ar(Impulse.ar(1), 0.01, 0.2, FSinOsc.ar(freq)) *
Linen.kr(gate, 0.01, 0.7, 0.3, 2);
OffsetOut.ar(i_out, Pan2.ar(out, pan, amp));
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

		out = out * 0.05;
		out = out.clip2(1);

		Out.ar(outBus, out.dup);
	}).send(s);



SynthDef(\ixibass, {arg out=0, amp=0.3, t_trig=1, freq=100, rq=0.004;
	var env, signal;
	var rho, theta, b1, b2;
	b1 = 1.98 * 0.989999999 * cos(0.09);
	b2 = 0.998057.neg;
	signal = SOS.ar(K2A.ar(t_trig), 0.123, 0.0, 0.0, b1, b2);
	signal = RHPF.ar(signal, freq, rq) + RHPF.ar(signal, freq*0.5, rq);
	signal = Decay2.ar(signal, 0.4, 0.3, signal);
	DetectSilence.ar(signal, 0.01, doneAction:2);
	Out.ar(out, signal*(amp*0.45)!2);
}).add;

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

SynthDef(\majorpad, {
	arg blah = 67, out = 0;
	out = 0;
	out = SinOsc.ar((blah).midicps(),0,0.5,0);
	Out.ar([0,1],out);
}).send(s);
)
/*var synth,synth2;
synth = Pbind( \instrument, "fender2",
	\midinote,Pseq([0,1,60,64,2],3)).play;
*/
(

var melody = Pbind( \instrument, "ixibass",
	\dur, Pseq([
		Pseq([1/3],20*7),
		Pseq([1/6],2*14),
		Pseq([1/12],2*98-14)
	],1),
	\legato, 0.01,
	\midinote, Pseq([
		Pseq([7, 0, 4, 7, 5, 7, 4] + 60,16),
		Pseq([61],7*8),
		Pseq([0,2,4,0,5,0,12]+61,9)
	],1),
	\amp, Pseq([0.25, 0.125, 0.125, 0.2,0.125,0.2,0.125],inf)
).play(TempoClock(4/3));
/*
var bass = Pbind( \instrument, "fender2",
	\dur, 1/2,
	\midinote, Pseq([0,0,0,0, 55,60],inf),
	\amp, Prand([0.25, 0.125, 0.125, 0.2,0.125,0.2,0.125],inf)
).play;
*///Airy Bass use fender

var drop = Pbind(
	[\midinote, \dur,\amp], Pseq([[0,(24*7+1)/3,0],[30,7/3,5]],1)
).play(TempoClock(4/3));

var snare = Pbind(\instrument, "snare",
	\dur, Pseq([
		Pseq([58/3,7/3,7/3,7/3,7/3,7/3,7/3,7/3,4/3+56/3],1)
	],1)
	).play(TempoClock(4/3));

var bd = Pbind( \instrument, "kick",
	\dur, Pseq([
		Pseq([28/3],1),
		Pseq([1/2,1/2,2/3,2/3], 12),
		Pseq([98/300],4*7),
		Pseq([(98/300)/2],2*14),
		Pseq([(98/300)/4],67)
],1)
).play(TempoClock(4/3));

var bd2 = Pbind(\instrument, "kick",
	\dur, Pseq([
		Pseq([16*7/3],1),
		Pseq([1/2,1/2,2/3,2/3], 8),
		Pseq([3],1),
		Pseq([3/8,3/16,3/16,3/16,3/8,3/16,3/8,3/8,3/4],4),
		Pseq([
			Pseq([3/8,3/16,3/16,3/16,3/8,3/16,3/8,3/8,3/4],1),
			Pseq([3/8,3/16,3/16,3/16,3/8,3/16,3/32,3/32,3/32,3/32,3/8,3/4],1)
		],7),
		Pseq([
			Pseq([3/8,3/16,3/16,3/16,3/8,3/16,3/8,3/8,3/4]+0.01,1),
			Pseq([3/8,3/16,3/16,3/16,3/8,3/16,3/32,3/32,3/32,3/32,3/8,3/4]+0.01,1)
		],4)
	],1)
).play(TempoClock(4/3));

var melody2 = Pbind(
	\midinote, Pseq([
		Pseq([52],1),
		Pseq([52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
			52, 59, 52, 60, 62, 64]+9,6),
		Pseq([52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
			52, 59, 52, 60, 62]+7,1),
		Pseq([52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
			52, 59, 52, 60, 62]+5,1),
		Pseq([52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
			52, 59, 52, 60, 62]+3,1),
		Pseq([52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
			52, 59, 52, 60, 62]+1.5,1),
		Pseq([52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
			52, 59, 52, 60, 62]+0.7,1),
		Pseq([52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
			52, 59, 52, 60, 62]+0.5,1),
		Pseq([52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
			52, 59, 52, 60, 62]+0.3,1),
		Pseq([52, 57, 52, 59, 52, 60, 59, 57, 52, 57,
			52, 59, 52, 60, 62],1)
	],1),
	\dur, Pseq([
		Pseq([(24*7/3)+6],1),
		Pseq([3/8],inf)
	],1),
	\amp, Pseq([
		Pseq([0],1),
		Pseq([0.1],inf)
	],inf)

).play(TempoClock(4/3));

var snare2 = Pbind(\instrument, "snare",
	\dur, Pseq([
		Pseq([(24*7/3)+9+(3/8)+(3/16)],1),
		Pseq([9/16,15/16],60)
	],1)
	).play(TempoClock(4/3));
/*
var pad = Pbind(\instrument, "majorpad",
	\dur, 14/3,
	\blah, Pseq([60,67,64],inf)
).play(TempoClock(4/3));
*/

var cym2 = Pbind(\instrument, "garbageCanLid",
	\amp,1,
	[\dur,\freq], Pseq([
		Pseq([[(24*7/3)+42+(3/8)+(3/16),4000]],1),
		Pseq([[1/2,6800],[1/2,4500],[1/2,2400]],12),
		Pseq([[99/200,9000],[99/200,400],[99/200,3200]],5*3),
		Pseq([[68/200,1000]],20*3),
	],1)
	).play(TempoClock(4/3));

var synth = Pbind( \instrument, "fender2",
	\dur, Pseq([
		Pseq([1/3],8*7+8*7)
	], 1),
	\legato, 0.01,
	\midinote, Pseq([
		Pseq([0,0,0,0,0,0,0], 8),
		Pseq([67,60,69,67,72,69,60],8)
],1),

).play(TempoClock(4/3));

var cym = Pbind(\instrument, "garbageCanLid", //Muse it up
	[\freq, \dur],
	Pseq([
		Pseq([[1000,28/3]],1),
		Pseq([[3810, 2], [1800, 2], [810, 2],[4800,2]],4)
	],1)
).play(TempoClock(4/3));

/*var lead = Pbind( //This is stupid
	\mul, 0.3,
	[\midinote,\dur], Pseq([
		[67,1/3],[65,1/3],[62,1/3],[60,4/3], [62,2/3]
    ])).play;
*/
//Ppar([melody,bass,bd]).play(TempoClock(1));
)



