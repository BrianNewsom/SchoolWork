//Brian Newsom
//Assignment 2
s.boot;
(
SynthDef("funkyGroove",
{
	arg bassFreq = 80, pitchChange = 0.6, tempo = 2;
	//bassFreq
	//pitchChange //Val between 0 and 1, smaller = more variation
	//tempo //Also changes length of cresc.
	a=Decay2.ar(Impulse.ar(tempo),1e-4)*SinOsc.ar(bassFreq);
	x = (Compander.ar(Blip.ar([40,40.5]*TChoose.kr(a > pitchChange ,(1..8)),4),a,8e-3,1,0.001,0.1,1/3)+a);
		Out.ar([0,1], x);
}).send(s);
)

a = Synth("funkyGroove");
a.set(\bassFreq, 16000);
a.set(\pitchChange, 0.4);
a.set(\tempo, 10); //Set to 20 with bassfreq 1000 to make bell
a.free;

(

SynthDef("Sin",
{
	arg freq = 440, mul = 0.5;
		x = SinOsc.ar(freq, 0, mul);
		Out.ar([0,1],x);
}).send(s)
)

b = Synth("Sin");
b.set(\freq, 80, \mul, 0.1,);
b.set(\freq, 2000)
b.free;

(
SynthDef("wibbly",
	//38nonprivate on sccode.org
	{
	arg out = 0, freq = #[60, 69, 64], amp = 0.5, lagTime = 0.1, trigRate = 3, detune = 0.2, noOfSynths = 20;
	var output;
	var maxNoOfTones = 5;

	output = Mix.fill(
		maxNoOfTones,
		{
		arg index;

		var trig, pitches, dseq_index;
		trig = Impulse.kr(0) + Dust2.kr(trigRate);
		dseq_index = Drand([0, 1, 2], inf);

		pitches =
			Lag.kr(
				Select.kr(Demand.kr(trig, 0, dseq_index), freq) + TRand.kr(detune.neg, detune, trig),
				lagTime * Rand(0.8, 1.2)
			).midicps;


		SinOscFB.ar(
			pitches,
			Rand(0, 0.8),
			amp * Lag.kr(TRand.kr(0.8, 1.0, trig), lagTime * Rand(0.8, 1.2))
		)
		*
		(if(index < noOfSynths, 1, 0));

		}
	);

	output = Mix(output) * (1 / noOfSynths) * Line.kr(0.0, 1.0, 0.3);

	Out.ar(out,	output ! 2);

	}
).send(Server.default);
)

c = Synth("wibbly");
c.set( \freq, [60, 64, 69], \detune, 0, \lagtime, 0.1); //C major (supposedly)
c.set(\freq, [100, 43, 40], \detune, 100); //Sparse high freq Wall-E noise
c.free;

(
SynthDef("Drums",
{
	arg tempo = 4;
	var exc, amp;
	amp = LFPulse.kr(tempo,0,0.1,0.002);//change the freq arg to change tempo
	exc = LPZ1.ar(GrayNoise.ar([amp,amp]));
	a = Klank.ar(`[FloatArray.fill(4, { rrand(80.0,400.0) }),
			nil,
			FloatArray[1, 1, 1, 1]], exc);
		Out.ar([0,1],a);
}).send(s);
)

d = Synth("Drums");
d.set(\tempo, 1)

////////COMPOSITION BEGINS HERE
(
b = Synth("Sin");
b.set(\freq, 80, \mul, 0.1,);
)
b.set(\freq, 125);
b.set(\freq, 110);
b.set(\freq, 160);
b.set(\freq, 105);
b.set(\freq, 80);
(
c = Synth("wibbly");
c.set(\amp, 0.2)
)
(
b.free;
a = Synth("funkyGroove");
)
d = Synth("Drums");
d.free; //If screwed up time
d.set(\tempo, 3)
c.set(\freq, [80, 70, 100], \detune, 100, \amp, 0.15); //High freq bendy noises

a.set(\tempo,0.4)
( //Robotic Section
a.set(\tempo, 15, \pitchChange, 1000, \bassFreq, 50);
c.set(\freq, [200,205,500], \detune, 100, \amp, 0.9); //Wall-E
d.set(\tempo, 100)
)

( //DescENDING
a.set(\pitchChange, 0.4, \tempo, 0.4);
b.free;
c.free;
b=Synth("Sin");
b.set(\freq,80);
)
(
b.set(\freq,70, \mul, 0.2);
d.set(\tempo, 20);
)
(
b.set(\freq,60, \mul, 0.3);
d.set(\tempo, 3);
)
(
b.set(\freq,50, \mul, 0.4);
d.set(\tempo,1);
)

( //Just Bassy
b.set(\freq,40,\mul, 0.3);
a.free;
d.free;
)

//Kill B - reduces clip
b.set(\mul, 0);
b.free;
