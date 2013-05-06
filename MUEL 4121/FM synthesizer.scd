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

(
{
	var mul, offSet;
	mul = MouseX.kr(50,500);
	offSet = MouseY.kr(200,2000);

	x = SinOsc.ar(SinOsc.kr(200,0,mul,offSet),0,0.5,0);
	y = FreeVerb.ar(x,0.7,0.8,0.5);
	Out.ar([0,1],y)

 //ar produces richer signal
}.play;
)