
/*
MUSC 4121-5121
FINAL PROJECT

Your final project may be a composition, an instrument, an
effects processor, or any other musical device. Your project
should be constructed using SuperCollider as the primary
component.

Some possible ideas:

Fixed media composition made from SC synthesis and or SC
processed sound files realized in Finale, Logic, GaragBand, etc.
If you are using a DAW you should use it as a sequencer only and
do not use any effects plugins, all effects will be done in SC.

Composition for acoustic instruments accompanied by SC, either
with real-time DSP or synthesis or both.

Self contained "push play" composition using nested envelopes or
patterns.

A set of audio effects.

An animation using SC graphic objects.

Etc., etc., etc..............

The projects will be due on Monday May 6th at 1:30pm. Turn in any
related materials, including your source code, at that time.

*/



(
//--server setting
s.options.memSize= 262144;
s.latency= 0.1;
s.waitForBoot{
//--window size
var width= 1024, height=768;
//--sounds
var syn0= SynthDef(\syn0, {|mof= 0, dep= 0, caf= 0, amp= 0, spr= 0|
 var mod= Pulse.ar(mof, 0.5, dep, dep/4);
 var car= SinOsc.ar(caf, mod, amp);
 Out.ar(0, Splay.ar(car, spr, amp, 0));
}, #[0.06, 0.01, 0.03, 0.01, 0.01]).play(s);

var syn1= SynthDef(\syn1, {|mof= 0, dep= 0, caf= 0, amp= 0, pan= 0|
 var mod= Saw.ar(mof, 0, dep);
 var car= SinOsc.ar(caf, mod, amp);
 Out.ar(0, Pan2.ar(car, pan, amp));
}, #[0.01, 0.01, 0.01, 0.01, 0.01]).play(s);

var syn2r= SynthDef(\syn2r, {|mof= 0, dep= 0, caf= 0, amp=0, pan= 0|
 var mod= Saw.ar(mof, 0, dep);
 var car= SinOsc.ar(caf, mod, amp);
 Out.ar(0, Pan2.ar(car, pan));
}, #[0.04, 0.04, 0.04, 0.04, 0.04]).play(s);

var syn2l= SynthDef(\syn2l, {|mof= 0, dep= 0, caf= 0, amp=0, pan= 0|
 var mod= VarSaw.ar(mof, 0.2, 0.5, dep);
 var car= SinOsc.ar(caf, mod, amp);
 Out.ar(0, Pan2.ar(car, pan));
}, #[0.01, 0.01, 0.01, 0.01, 0.01]).play(s);

var syn3= SynthDef(\syn3, {|mof= 0, dep= 0, caf= 0, amp=0, pan= 0|
 var mod= LFSaw.ar(mof, 0.5, dep);
 var car= SinOsc.ar(caf, mod, amp);
 Out.ar(0, Pan2.ar(car, pan, amp));
}, #[0.01, 0.01, 0.01, 0.01, 0.01]).play(s);

var syn4= SynthDef(\syn4, {|mof= 0, dep= 0, caf= 0, amp=0, pan= 0|
 var mod= LFSaw.ar(mof, 0.5, dep);
 var car= SinOsc.ar(caf, mod, amp);
 Out.ar(0, Pan2.ar(car, pan, amp));
}, #[0.05, 0.05, 0.05, 0.05, 0.05]).play(s);

//--window setting
w= Window("|", Rect(200, 200, width, height), false);
//w= Window("|", Rect(0, 0, width, height), false, border:false);
//mirroring
//w= Window("|", Rect(1440, 132, width, height), false, border:false);
//output
v= UserView(w, w.view.bounds);
v.background= Color.black;
v.animate= true; //*** if you use swingosc, just comment out this line and
//uncomment following line marked by '***' but sorry, i guess it may be very
//slow...
 //--parameters initial setting
~seq= 0;
~subseq= 0;
~num= 1000;
~a= 1@1;
~aa= 1@1;
~f= 0;
~ff= 0;
~z= 1e-4;
~zz= 3;
~r= 1;
~d= 1;
~cnt= 8e-8;

v.drawFunc= {
var x, y, yxx, temp, xx, yy;
var wh= width/2, hh= height/2, wq= width/4, xo= width/8, yo= height/8;
var sa= sin(2pi*~r), ca= cos(2pi*~r);

Pen.strokeColor= Color.white;
//--seq0
if(~seq==0, {
//--mess up henon map calculation
x= exprand(2,6)-4;
y= exprand(2,6)-4;
yxx= y-(x*x%x).tanh;
temp= (x*ca)-(yxx*sa);
y= (x*sa)+(yxx*ca);
 x= temp;
 xx= xo + (width/30*x.sin);
         yy= yo - (height/30*y.cos);

         Pen.translate(wh, hh);
         ~num.do{
         ~p0= (xx@yy)+~d;
         ~p1= ~a*hh%~p0;
         ~p2= (~a=(~a+~z*(~f=~f+~cnt)).x.sin@~a.x.tanh+~z)*~p0/2;
         ~p3= (~p1%~p0)*2;
         ~p4= (~p2%~p0)*2;
         Pen.line(~p3, ~p4);
         Pen.rotate(1);
         };
         Pen.stroke;
         syn0.set(
         \mof, (~p3.x+~p4.x).abs/3,
         \dep, (~p3.y+~p4.y/2).abs/5,
         \caf, 64,
         \amp, 0.72,
         \spr, (~p3.x+~p4.x/2).linlin(width.neg*0.5, width*0.5, 0, 1)
         );
         //--control
         if(~z<0.05,{~z= ~z*1.004},{~z= ~z*1.0006});
if(~z>0.3, {~z= ~z*1.001; ~cnt= 1e-7});
if(~f>0.15, {~cnt= 1e-6; ~r= 0.1});
if(~f>0.75, {~cnt= 5e-6; ~d= ~d*1.001});
if(~f>1.2, {~r= 0.768; ~cnt= 8e-6;});
if(~f>1.5, {~r= 0.168; ~d= ~d*1.007});
if(~d>2000, {~cnt= 0; ~z= 0.25; ~f= 0; ~d= 250; ~ct.start});
~ct= Task({
80.wait; //better to comment-out when you check the sequence
~f= 0;
~z= 10;
~cnt= 1e-6;
~num= 600;
~seq= 1;
syn0.free;
}, AppClock);
});
//--seq#1
if(~seq==1, {
~num.do{
~p1= ~a*hh;
~p2= (~a=(~a+~z*(~f=~f+~cnt)).x.sin+1.7@~a.x-0.35)*hh;
Pen.line(~p1, ~p2);
};
Pen.stroke;
syn1.set(
\mof, ~p1.x+~p2.x/2,
\dep, (~p2.x-~p2.y).abs/hh*1500,
\caf, 100+(~f*2),
\amp, 0.67,
\pan, 2*(~p1.x+~p2.x/2)/width-1
);
//--control
~z= ~z*1.0003;
~cnt= ~cnt*1.0001;
if(~f>3, {~z= ~z*1.0005; ~cnt= ~cnt*1.0005});
if(~f>5, {~z= ~z*1.001; ~cnt= ~cnt*1.001});
if(~f>10, {~f= 0; ~z= 0.1; ~cnt= 0; ~seq= 2; syn1.free});
});
//--seq#2r
if(~seq==2, {
400.do{|i|
~p1= ~a*wq;
~p2= (~a=(~a+(i*~z)*(~f=~f+2e-6)).x.cos+4@~a.x-1)*wq;
Pen.line(~p1, ~p2);
};
Pen.stroke;
syn2r.set(
\mof, (~p1.x+~p2.x),
\dep, (~p2.x-~p2.y).abs/wq*1500,
\caf, 75+(~f*2),
\amp, 0.3,
\pan, 2*(~p1.x+~p2.x/2)/width-1
);
//--control
~z= ~z*1.0002;
if(~f>2, {~subseq= 1; ~z= ~z*1.0005});
});
//--seq#2l
if(~subseq==1, {
400.do{|i|
~p3= ~aa*wq;
~p4= (~aa=(~aa+(i*2)+~zz%(~ff=~ff+6e-6)).y.sin+1@~aa.x)*wq;
Pen.line(~p3, ~p4);
};
Pen.stroke;
syn2l.set(
\mof, (~p3.x+~p4.x)/4,
\dep, (~p4.x-~p4.y).abs/wq*800,
\caf, 50+(~ff*2),
\amp, 0.3,
\pan, 2*(~p3.x+~p4.x/2)/width-1
);
//--control
~zz= ~zz*1.002;
if(~zz>2000, {
~a= 1@1;
~f= 0;
~ff= 0;
~z= 0.5;
~zz= 0;
~num=1001;
~cnt= 7e-7;
~subseq= 0;
~seq= 3;
syn2r.free;
syn2l.free;
});
});
//--seq#3
if(~seq==3, {
Pen.translate(wh, hh);
~num.do{|i|
~p1= ~a*i/1.68;
~p2= (~a= (~a+~z*(~f=~f+~cnt)).y.tan@~a.x.tanh)*hh;
Pen.line(~p1, ~p2);
};
Pen.stroke;
syn3.set(
\mof, ~p1.y+~p2.y,
\dep, ~p1.y+~p2.y/16,
\caf, 640+(~f*12),
\amp, 0.55,
\pan, (~p1.x+~p2.x/2).linlin(width.neg*0.5, width*0.5, -1, 1)
);
//--control
if(~f<1, {~z= ~z*1.001},{~z= ~z*1.0015});
if(~f>1.2, {~z= ~z*1.002; ~cnt= 1e-6});
if(~f>1.4, {~z= ~z*1.003;});
if(~f>1.6, {~z= ~z-0.08; ~cnt= 3e-6});
if(~f>2.8, {
~a= 1@2;
~f= 0;
~z= 1;
~d= 2;
~num= 1001;
~cnt= 1e-8;
~seq= 4;
syn3.free;
});
});
//--seq#4
if(~seq==4, {
Pen.translate(wh, hh);
~num.do{|i|
~p1= ~a*i/~d;
~p2= (~a= (~a*~z.trunc(~f=~f+~cnt)).y.tan@
(~a*~z).x.tanh.atan.reciprocal)*hh;
Pen.line(~p1, ~p2);
};
Pen.stroke;
syn4.set(
\mof, ~p1.y+~p2.y,
\dep, ~p1.y+~p2.y/16,
\caf, 640+(~f*12),
\amp, 0.55,
\pan, (~p1.x+~p2.x/2).linlin(width.neg*0.5, width*0.5, -1, 1)
);
//--control
if(~f<0.005, {~z= ~z*1.0007}, {~d= ~d*1.001; ~z= ~z*1.003});
if(~f>0.01,{~cnt= 2e-7; ~z= ~z*1.01});
if(~z>10000, {~z= 5000});
if(~d>10, {~f= 30; ~z= -1; ~num= 909; ~d= ~d*1.007});
if(~d>200, {~d= 10; ~f= 77; ~z= -1000; ~num= 999; ~qt.start});
~qt= Task({20.wait; w.close}, AppClock);
});
};
//c= ClockFace.new.play; //quakrs: ClockFace
w.front;
//({while({w.isClosed.not}, {w.refresh; (1/60).wait})}).fork(AppClock);//***
w.onClose= {syn0.free; syn1.free; syn2r.free; syn2l.free; syn3.free;
syn4.free; /*c.window.close;*/};
CmdPeriod.doOnce({if(w.isClosed.not, {w.close})});
};
)

//--check the sequence
~f=1
~d=2000
~f=10
~f=2.5
~zz= 2000
~f= 2.8
~f= 0.01
~z= 10000
~d= 10
~d= 200



--
itaru yasuda
http://www.itaru.org/

