s.boot;

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/DM-ProcessedEthnPerc47.wav"); // remember to free the buffer later.

{PlayBuf.ar(1, 0)}.play(s); // Your buffer number may differ

[b.bufnum, b.numChannels, b.path, b.numFrames].postln;
LinLin.ar(LFSaw.ar(1), -1, 1, 1.5, 2.5)*44100
s
(//Loop
{
var bufNum = 0, srate = 44100, start = 0.21, end = 0.74,
	rate = 1, totalDur = 20, pan = 0;
var out, duration, total;
start = [0, 0]; end = [0.2, 0.3]; //[.2,.3]
total = BufFrames.kr(bufNum)/44100;
end = end*total; start = start*total;
duration = abs(end - start);
BufRd.ar(1, bufNum, // Buffer 0
	LinLin.ar(
		LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
	)*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
		gate: Impulse.kr(1/duration));
}.play
)

(//Pan across phase
var n;
n = 12;
{Mix.fill(n, { arg i;

			Pan2.ar(
	                PlayBuf.ar(1, b.bufnum, 1.0 + (XLine.kr(0.0013,0.13,120) * i), 0, 0, b.bufnum.size-2),
				2.0/(1-n) * i + 1)})

}.scope(1);
)