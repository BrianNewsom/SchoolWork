s.boot;

( // synchronized triggers MAD POLYRYHTHMS
{
var synch = 1;
SinOsc.ar(60, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(3/synch))) +
SinOsc.ar(60, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(7/synch))) +
SinOsc.ar(60, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(5/synch))) +
SinOsc.ar(60, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(2/synch))) +
SinOsc.ar(60, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(9/synch))) +
SinOsc.ar(60, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(6/synch))) +
SinOsc.ar(60, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(1/synch))) * 0.1
}.play
)

(
{
	SinOsc.ar(MouseY.kr(0,1000),
		mul: EnvGen.kr(
			//Envelope is attack, decay, sustain level, release
			Env.adsr(0.001, 0.3, 0.2, 2.1),
			MouseX.kr(-0.1, 0.1) //gate
		)
	)
}.play
)