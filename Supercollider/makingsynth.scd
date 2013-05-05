(
SynthDef("TJ",
{
arg freq = 4;
var out;
out = CombN.ar(
   SinOsc.ar(
     LFNoise1.kr(
         freq,
         24,
           LFSaw.kr(
                [8,7.23],
				 0,
                 3,
                 80
                    )
                  ).midicps,
                 0,
                 0.04
            ),
        0.2,
        0.2,
        4
		);
		Out.ar(0,out);
	},
	[5,2]).send(s)
)

a = Synth("TJ", \freq );
a.set(\freq, 50);