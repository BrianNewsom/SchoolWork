s = Server.local.makeWindow;
(
SynthDef("TJ",
{
	arg freq = 606
	x = SinOsc.ar(freq,0,0.2,0);
	Out.ar([0,1],x)
}).send(s)
)

a = Synth("TJ",[\freq 303])

a.set(\freq, 67.midicps);
