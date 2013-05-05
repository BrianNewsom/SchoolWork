s = Server.local.makeWindow;
(
{
	SinOsc.ar(SinOsc.kr(2,0,MouseX.kr(2,400),MouseY.kr(1,1000)),0,0.5,0)
}.scope;

)

(
{
		SinOsc.ar(
			Saw.kr(MouseX.kr(0,100),50,440)
		,0,MouseY.kr(0,1),1)
}.play;
)