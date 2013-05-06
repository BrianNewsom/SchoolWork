//BRIAN NEWSOM ASSIGNMENT 3
s.boot;
(//Rising pitches in sin and saw
{
var sine, saw, fifths, bassy, ocean, beats,drums, pitch1; //Patch names
var freq, ratioNum, ratioDenum, mul, mulEnv1, freqEnv1, freqEnv2, mulEnv2, mulEnv4, mulEnv6, mulEnv7, tempEnv1,sinEnv1; //Declare Envs
ratioNum = 3; //assign numerator
ratioDenum = 2; //assign denominator

freq = Env.new([1000,1000,400,60, 0,0,70,20000],
		times:[20,5,10,5,10,30,12,7]);
mul = Env.new([0,0.0,0.3,0.2,0,0.3],
		times:[20,3,5,5,10, 5,30,5]);

mulEnv1 = Env.new([0,0, 0.5, 0.5, 0], //env for sine
			[20,5, 8, 2],
			[1, 0, 0]); //Leave blank for linear

freqEnv1 = Env.new([40,40, 2000, 880, 220],
	times:[20,5,8,5],
	curve:'exp');

freqEnv2 = Env.new([0,0, 0, 2000, 220],
	times:[20,5,2,7,4]);

mulEnv2 = Env.new([0,0.5,0],
	times:[20,15,5]);

mulEnv4 = Env.new([0,0.3,0.2,0],
	times:[5,4,25]);

mulEnv6 = Env.new([0,0,0,0,0.5,0,0,1,0],times:[7,5,15,8,0.5,2,4,11]);

mulEnv7 = Env.new([5,5,3,0],times:[4,4,7,4,4],curve:'exp');

tempEnv1 = Env.new([0.001,0,1,4,5,4,100,0],times:[50,5,6,4,5,5,14]);

sinEnv1 = Env.new([0,440,0],times:[50,5,7],curve:'exp');

sine = {
	SinOsc.ar(EnvGen.kr(freqEnv1), 0, EnvGen.kr(mulEnv1))};


saw = {
	Saw.ar(EnvGen.kr(freqEnv2),EnvGen.kr(mulEnv2))};

fifths = {
		Blip.ar(
		[EnvGen.kr(freq), EnvGen.kr(freq)*(ratioNum/ratioDenum)], 5,
			EnvGen.kr(mul))};
bassy = {
	Mix.new(
	Array.fill(10,
	{arg counter;
	var partial;
	partial = counter*2;
				SinOsc.ar(Rand(50,100)*EnvGen.kr(Env.adsr(0,0,1.0,2.0),timeScale: 1/partial));//levelBias: 0.5)
		})*EnvGen.kr(mulEnv4);
	)};
ocean = {
		x = OnePole.ar(WhiteNoise.ar(EnvGen.kr(mulEnv6))+Dust.ar(0, 0.5), 0.7);
		x = x + Splay.ar(FreqShift.ar(x, 1/(4..7)));
	};
beats= {
		a = Impulse;tanh(a.kr(8).lag*Crackle.ar(LFSaw.kr(3).abs.lag*1.8)+GVerb.ar([a.kr(2)+a.kr(4,0.5)].lag*Blip.ar(4.9,7,0.4)!2,1,1)*EnvGen.kr(mulEnv7));
	};

drums = {
	var exc, amp;
	amp = LFPulse.kr(EnvGen.kr(tempEnv1,doneAction:2),0,0.1,0.002);//change the freq arg to change tempo
	exc = LPZ1.ar(GrayNoise.ar([amp,amp]));
	Klank.ar(`[FloatArray.fill(4, { rrand(80.0,200.0) }),
			nil,
			FloatArray[1, 1, 1, 1]], exc);
	};

pitch1 = {
		SinOsc.ar(EnvGen.kr(sinEnv1),0,0.5);
	};

	LeakDC.ar(saw+sine+fifths+bassy+ocean+beats+drums+pitch1);
}.play;
)



