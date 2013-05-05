s.makeWindow.boot;

/*
Tutorial
Busses and Nodes and Groups; Linking Things Together

Disclaimer
This is a very difficult chapter. Log off of YouTube.

Busses and nodes are new in SC3, and there is a lot to cover. I may betray my tendency to
know just enough of the programming side to do what I want compositionally. My goal is to
get you familiar enough with busses, nodes, and groups to do some easy examples and also
allow you to follow the examples and help files.

Just a reminder before we dive into this discussion; the code below shows a useful tool for
remembering the structure of synth definitions. It can also be used to review or learn bus
assignments.


Synth definitions - review

Creating synth definitions is like building a little synthesizer; virtual metal boxes that make
sound. Like real hardware devices the wiring, once sent to the server, can't be changed. Look
at the first example below. It will always have an LFNoise as the
frequency control and the arguments will always be 10, 15, 400, and 800. It's as if we had
built the synthesizer in a closed box with no controls or inputs. We can redo the code, but
then it is a different synth.


First Patch (play, SinOsc, LFNoise0, .ar)
*/

{SinOsc.ar(LFNoise0.ar([10, 15], 400, 800), 0, 0.3)}.play

/*
We gained more flexibility by replacing the static values with arguments, and using set to
change the values as shown below. Now our virtual box at least has knobs for changing
parameters.

First SynthDef
*/

//SynthDef (naming it) and arguments

(
SynthDef("RandSine",
{
arg rate = 9, scale = 300, offset = 600, pan = 0, out;
out = Pan2.ar(SinOsc.ar(LFNoise0.ar(rate, scale, offset), mul: 0.3), pan);
DetectSilence.ar(out, doneAction:2);
Out.ar(0, out)
}).add
)

// execute these separately
a = Synth("RandSine", [\pan, -1, \rate, 8]);
b = Synth("RandSine", [\pan, 1, \rate, 13]);
b.set(\offset, 2000);
a.set(\rate, 20);
b.set(\rate, 6);
a.set(\scale, 550);
a.free;
b.free;
/*

But the internal wiring, the diagram or flow chart of the RandSine will remain the same. It
will always have an LFNoise0 as a control.

To change the control source to something else, an LFNoise1, a sequencer, or S&H, we
would have to rewrite the patch with those controls; build a new box, so to speak. This was
one of the limitations with SC2. A modular approach would be more efficient, that is build
the LFNoise0, LFNoise1, and S&H controls as separate patches from the SinOsc, then patch
whichever one we want to use to the SinOsc. SC3's architecture was designed with this in
mind. It allows you to run several patches at a time, even the same patch several times, and it
allows you to connect those patches together using a bus.

In all patches there are outs and ins. The LFNoise0 has an output and the SinOsc is using that
output in one of its inputs. I've used the terms send, control, source, or modulator for an
output, and receive, filter, carrier, for an input. But no matter how you use it, there is an
output from one unit and an input for another. So far we have connected them by nesting
them inside one another. Now we will learn how to use busses to connect them together.
Busses are common in mixers and are used to route several signals to or from a common
destination. They don't usually change the signal in any way, they just route it. They are like
city busses or shuttles. A worker boards a bus, two or three other workers join along the
way and ride to "work" or their destination. They can all get off at one place, or several
places. There are 16 or so busses that take people to different factories. We can do the same
with signals. The output of one ugen would be the people, and the destination might be a
reverb unit.

I've had students ask, after routing the signal to a bus, where it has gone. (That is, what fx
unit or headset send have I routed it to?) The answer is nowhere. They don't really go
anywhere specific. They are just patch points or cables, and like city shuttles it is important
to understand that you define what they are; who gets on and where they go.

Audio and Control Busses

There are two kinds of busses in SC: audio and control. In an earlier example the scope
window showed 12 sine waves. These were playing on 12 busses. We could hear the top two
because they were routed to the computer's output. The others were routed to audio buses 4
through 12, which were probably not connected to an output that you could hear.
You inter-connect audio busses using Out.ar and In.ar. The control busses use Out.kr and
In.kr. There are 128 audio busses and 4096 control busses. If you're used to classic studios
imagine a snake (or patchbay) with 128 patch points numbered 0 through 127. One end of the
snake is labeled "In.ar" and the other "Out.ar," and another completely separate snake with
4096 patch points numbered 0 through 4095. What are they connected to? Nothing yet, with
this exception: On most systems the audio busses 0 and 1 are routed to the left and right
channel output of your hardware (computer sound out). Confirm this with {Out.ar(0,
SinOsc.ar)}.play and {Out.ar(1, SinOsc.ar)}.play. Similarly, 2 and 3 by default are
connected to the hardware input. Run {In.ar([2, 3])}.play to confirm this. (Use headsets to
avoid feedback.) If you tried {In.ar(0)}.play you would be listening to your speaker.
Likewise {Out.ar(2)}.play would send signal to your internal mic. When you do
{anything}.play it is automatically routed to outs 0 and 1. So {In.ar([2, 3]}.play is the same
as {Out.ar([0, 1], In.ar([2, 3])}.play.

The control busses have no default connections.

To illustrate control and audio busses, run these lines of code. Remember that an array will
be expanded to that many channels, as is evident in the scope. We only hear the first two
channels (unless you have a multi-channel interface). We don’t hear any of the control
busses. Note that a control scope is blue, audio scopes are yellow.

Make sure your internal server is booted.

Audio and Control Busses
*/

(
{
	[
		SinOsc.ar,
		PinkNoise.ar,
		LFNoise1.ar,
		LFNoise0.ar,
		LFTri.ar,
		WhiteNoise.ar
	]*0.4
}.scope
)

// Control busses
//kr uses control bus
(
{
	[
		SinOsc.kr(100),
		Dust.kr(50),
		Impulse.kr(78),
		LFNoise0.kr(100),
		LFNoise1.kr(100),
		WhiteNoise.kr
	]*0.4
}.scope(zoom: 10)
)
/*
Below is the first patch broken up into two components. The SinOsc and the LFNoise0. The
Out object indicates which bus the signal is routed to and the first argument is the bus
number. You can enter a single number for a mono signal, or an array for a stereo signal. But
even if you don't enter an array the correct number of busses is automatically allocated. If the
patch is a stereo signal (e.g. using multi-channel expansion) and the bus number in Out is 0,
then it will actually use 0 and 1. If the signal has four channels and the bus out is 4 it will use
4, 5, 6, and 7. You are responsible for making sure there are no conflicts.

The LFNoise0 module is sent to control bus 9. (Remember there are control busses and audio
busses. The .kr message will use control busses.) I’ve written the patch with the mul and add
outside the LFNoise so that it displays on the scope.

When I isolate the LFNoise in the third example, you hear it in both channels, but it is just a
series of pops. When the SinOsc is moved to bus 5, you won’t hear it, but will see it in the
scope. Neither will you hear the last example because control bus 9 isn't connected to an
audio out. Why busses 5 and 9? To illustrate that the busses are arbitrary. You can use
whatever bus you want, as long as you connect the destination to the same bus number.

Assigning busses
*/
s.boot;
//Entire patch
{SinOsc.ar(LFNoise0.kr([10, 15]) * 400 + 800, 0, 0.3)}.scope

//Just the SinOsc
{SinOsc.ar(800, 0, 0.3)}.scope

//Just the LFNoise0
{LFNoise0.ar([10, 15])}.scope

//Just Sine patched to audio out 0
{Out.ar(0, SinOsc.ar(800, 0, 0.3))}.scope;

//Just Sine patched to audio out 5
{Out.ar(5, SinOsc.ar(800, 0, 0.3))}.scope(16);

//Just the LFNoise def
{Out.kr(9, LFNoise0.kr([10, 15], 1, 0))}.scope(16, zoom: 10) //STEREO, 2 channels

/*
Now two synths are running. One is producing audio on 5 the other is producing a control
rate signal that is riding around on control bus 9 waiting for us to tell it where to get off. It
needs to get off at the SinOsc factory. To get it there we use In.kr (not In.ar, which would
connect it to the audio bus). In the example below the first argument for In.kr is the bus
number (20) and the second is the number of channels (2). Why 20? Because that's where the
LFNoise is connected. The bus, so to speak, that it boarded. Why 2 channels? Because the
LFNoise0 is a stereo signal (frequency argument array), so it is using 20 and 21. In.kr reads
from control bus 20 and 21, which is where LFNoise0 is connected and uses that as a control.
SinOsc then plays to audio busses 0 and 1, because it is now a stereo signal too.

If you haven't already done so, press command-period to stop all processes.

I reverse the order in this example so you can start the LFNoise0 first. Watch the server
window to see that the cpu increases and a Synth is created with 5 or so Ugens even though
we don't hear it. Then start the SinOsc to hear the two patched together. Then reverse the
order so you can hear the Sine without the LFNoise0 patched in, then start the LFNoise0.

Patching synths together with a bus
*/

{Out.kr(20, LFNoise0.kr([8, 11], 500, 1000))}.scope

{Out.ar(0, SinOsc.ar(In.kr(20, 2), 0, 0.3))}.scope

/*
The next step is to use an argument for bus numbers so we can change it on the fly. Why
change the bus number while the synth is running? To connect it to a different control, which
I've added below, assigned to different busses. You could assign the busses on the controls
using an argument too. It's just not necessary for this example. You can define all the synths
at once inside parentheses. Once they are running note the server window displays Synths: 4
and quite a few Ugens. We only hear one of them: the sines without controls. The other two
are on control busses we don't hear. Run each a.set to assign a new bus number for the
PatchableSine input for In, thereby connecting whichever synth control is connected to that
bus and changing the control for frequency.


Patching synths together with a bus, dynamic control sources
*/

(
//Start all the synths
SynthDef("LFN0Control",
	{Out.kr(20, LFNoise0.kr([8, 11], 500, 1000))}).play(s);


SynthDef("SineControl",
	{Out.kr(22, SinOsc.kr([3, 3.124], mul: 500, add: 1000))}).play(s);


SynthDef("MouseControl",
	{Out.kr(24, MouseX.kr([100, 200], 1000))}).play(s);


a = SynthDef("PatchableSine",
	{arg busInNum = 0;
	Out.ar(0, SinOsc.ar(In.kr(busInNum, 2), 0, 0.3))}).play(s);
)

a.set(\busInNum, 20); //set to LFNoise0
a.set(\busInNum, 22); //set to SineControl
a.set(\busInNum, 24); //set to MouseControl
a.free;
/*
Why are the control busses numbered 20, 22, and 24? Try using 20, 21, and 22 to see what
happens.  It is less efficient to have all three controls running at once, so this will also work.
( See also ReplaceOut.)

Patching synths together with a bus, dynamic control sources
*/

a = Synth("PatchableSine", [\busInNum, 20]); b = Synth("LFN0Control");

b.free; b = Synth("SineControl"); a.set(\busInNum, 22);
b.free; b = Synth("MouseControl"); a.set(\busInNum, 24);

/*
It is possible to patch several controls to a single bus, or control several synths with a single
bus. In this example I use Out.kr(0) to illustrate that it is separate from Out.ar(0). Notice that
both controls are connected to bus 0, so they both control the receiver. In the second example
both receivers are connected to some arbitrary bus, so they are both controlled by that synth.
(It may sound like one synth so listen to the left headset then the right.)

Several controls over a single bus
*/

(
SynthDef("SendControl1", {
	Out.kr(0, SinOsc.ar(0.3, mul: 1000, add: 1100))}).add;
SynthDef("SendControl2", {Out.kr(0, LFNoise0.ar(12, 200, 500))}).add;
SynthDef("Receive", {Out.ar(0, SinOsc.ar(In.kr(0)))}).add);
)

Synth("Receive");
Synth("SendControl1");
Synth("SendControl2");

//Or

Synth("Receive");
Synth("SendControl2");
Synth("SendControl1");

//Or

(
SynthDef("SendControl", {Out.kr(1275, LFNoise0.ar(12, 200, 500))}).add;
SynthDef("Receive1", {
	Out.ar(0, RLPF.ar(PinkNoise.ar, In.kr(1275), 0.05))}).add;
SynthDef("Receive2", {Out.ar(1, SinOsc.ar(In.kr(1275)))}).add;
)

Synth("Receive1");
Synth("Receive2");
Synth("SendControl");

//Stop all using command-. Then try executing them in reverse order






/*
Nodes

It works in either order because it is a control bus. When working with audio buses order
does matter. When you create a synth SC stores it on a node or memory location. Each new
synth creation results in a new node (you see them in the post window when you start a
synth). Nodes are linked together. The computer knows the order and can add a new node
either at the beginning of the list (head) or at the end (tail) or anywhere else, for that matter.
Be aware that node number and node order are not related. The number is just an address,
and doesn't affect or refer to the ordering of the nodes. In the examples we've done so far this
connection process has remained behind the scenes. But now that we are patching synths
together we have to take control. We are not talking about in what order the synths are sent to
the server, but in what order they are created and start generating sound on the server.
Create the two synth definitions below then run the following examples. Notice that if you
run the Saw first, then the filter, you get no sound.


node order, head, tail
*/

(
//The definitions can be any order
SynthDef("Saw", { arg filterBus = 16;
	Out.ar(filterBus, LFSaw.ar([60, 90]))
}).add;

SynthDef("Filter", {arg filterBus = 16;
	Out.ar(0, RLPF.ar(In.ar(filterBus, 2), LFNoise0.kr(12, 300, 350), 0.2))
}).add;
)

//won't work
Synth("Saw"); //source
Synth("Filter"); //filter

//works
Synth("Filter"); //filter
Synth("Saw"); //source

//or
Synth("Filter"); Synth("Saw");

/*
In this example we are linking an audio source to a filter. I use audio busses for both signals
(Out.ar) because they both need to be audio rate. The source is sent out on 16. I can't use 0,
1, 2, or 3 because they are connected to my hardware out and in. Why not 5? Because I may
eventually use this on a machine that can handle 8 outs and 8 ins (0 through 15), so I move to
16 (though I could use 60 for that matter). See also dynamic bus allocation below.

The only difference between the two examples above is execution order. In the first example
Saw (the source) is started first, then Filter (the filter). The second creates Filter, then Saw.

When you create a new synth it is given a node id and placed at the head of the list. Any
synths that are already in the list are moved down. So if you execute the Saw first it is given a
node and placed at the head. Then when you execute Filter it is given a node number, placed
at the head bumping Saw to the tail. But signal flows from head to tail, so the Saw has to be
at the head and Filter at the tail.

I think of the head as the top of a flow chart because we used to diagram patches with signal
flowing down. Unfortunately this is confusing because it's opposite of the execution order, as
shown below.

But their order, head to tail, top to bottom is

Group(0)
        Group(1)
                Synth 1002 //head
                Synth 1001
                Synth 1000 //tail


Execution order, node order
*/

// This execution order

Synth("Receive");
Synth("SendControl1");
Synth("SendControl2");


/*
So the execution order is the reverse of the node list, top to bottom (head to tail).

Here is what I try to remember: Order of execution is inputs first, outputs second; receive
first, send second; destination first, departure second. By that I mean execute the synth that is
going to receive signal from another at its input bus. Execute the synth that is sending a
signal to be used second. (How about this: you have to build the factory before putting
workers on the bus. If you put them on a bus before their destination exists you can't tell
them where to get off.)

If you want to think of them as head or tail: inputs at the tail (bottom), outputs at the head
(top), because signal flows from top to bottom.

Execution order: Ins then outs. Node order: Ins at the tail, outs at the head.

When using Synth the node is placed at the head of the group by default. But you can also
explicitly assign a node to the tail or head.  With the example below the Saw is placed at the
head (which would happen anyway). The second expression places Filter at the tail instead
of the head which would move Saw to the tail. Using tail and head mean order of execution
doesn't matter.

When using the message head or tail the first argument is the group, the head or tail of which
the synth is placed. We haven't created any groups yet, so it is placed on the server itself,
which is a default first node with id 0 and has a default group of 1.

node order, head, tail
*/

Synth.head(s, "Saw");
Synth.tail(s, "Filter");

//Same

Synth.tail(s, "Filter");
Synth.head(s, "Saw");

/*
Dynamic bus allocation

In the previous example I used bus 16 in order to leave room for an 8 channel interface, 8 in,
8 out. What if you're not sure how many outs and ins you already have? Naturally, there is an
automated method for managing busses. Bus.control and Bus.audio can be used to return the
next available control or audio bus index. Bus.index returns that index. The first example
below results in this line in the post window: Bus(internal, audio, 4, 1), meaning a single
audio bus on the internal server at index 4 was returned. Why 4? because 0 through 3 are in
use by the computer's out and in, so 4 is the next available bus. The free messages frees that
bus to be allocated again. Next I reallocate a two channel bus to c, then a two channel bus to
b. They should be 4, 5, and 6, 7, but your mileage may differ; they will actually be whatever
is free on your system. I then send a Saw and SinOsc to each of these allocated busses, using
scope with 12 channels so you can see them all. Notice that both are stereo busses, but the
Saw is a mono patch. Even so, the second c bus is kept available.  ( Here are some tricks for scope: When you generate a scope, the scope window comes to the front. Use command-` to quickly cycle back to your code window. Use the up and down arrow keys to scroll through busses in the window, use tab and arrow to show more busses.)

Be sure to free each bus after each example, just so my explanations jive.


Bus allocation and reallocation
*/

b = Bus.audio;

b.index;

b.free;

c = Bus.audio(s, 2);
b = Bus.audio(s, 2);

{Out.ar(c.index, Saw.ar)}.play;
{Out.ar(b.index, SinOsc.ar([500, 1000]))}.scope(8);

b.free; c.free;

/*
If you bypass the Bus and just enter an index number it will not register with the bus
allocation. This is called hardwiring. To illustrate this I'll first take over some busses with a
hard wired dummy synth. Then I use Bus to get the next available bus, print its index, then
use its index to create a new synth. Notice that it is sent to the same busses as the first
SinOsc.


Bus allocation and reallocation
*/

{Out.ar(4, SinOsc.ar([100, 200, 300, 400]))}.scope(8);

b = Bus.audio(s, 2);

b.index; // should still be 4 regardless of above code

{Out.ar(b.index, Saw.ar([800, 1000]))}.scope(8); // adds to sines

b.free;

/*
Follow along and watch the post window while executing this set of instructions for bus
allocation.

Bus allocation
*/

a = Bus.audio(s, 2) // Get the next available 2 channels
b = Bus.audio(s, 1) // Get next 1 channel
c = Bus.audio(s, 2) // Get two more
c.index // print c
a.index // print a
a.free // free a
b.free // free b
d = Bus.audio(s, 1) // a and b are now free, so these
e = Bus.audio(s, 2) // should take over those indexes
a = Bus.audio(s, 2) // reallocate a and b, will probably
b = Bus.audio(s, 1) // 9 through 11
[a, b, c, d, e].postln; // print all of them
s.scope(14); // start a scope

// Now we start some synths. I'm going to mix them all
// down to bus 0, 1, so we have to start it first. Remember
// In first, Out second, receive first, send second.

{Out.ar(0, Mix.ar(In.ar(2, 12))*0.1)}.play
{Out.ar(a.index, SinOsc.ar)}.play
{Out.ar(b.index, SinOsc.ar(1000))}.play
{Out.ar(c.index, Saw.ar([400, 800]))}.play
{Out.ar(d.index, Pulse.ar(200))}.play
{Out.ar(e.index, [Saw.ar(500), FSinOsc.ar(900)])}.play
// You can get a bus without assigning it to a variable,
// you just won't be able to free it later.
{Out.ar(Bus.audio.index, Saw.ar(2000))}.play
// You can write two signals to a single bus
{Out.ar(a.index, Saw.ar(2000))}.play


[a, b, c, d, e].do({arg each; each.free}) // free all of them

/*
I have to admit I don't have a lot of experience with busses. My gut feeling is that dynamic
allocation could be either indispensable or just another unnecessary level of complexity. You
decide.

Using busses for efficiency

Busses can make your patches more efficient. You can use a single control for several synths,
or send several synths to a single global fx. If an fx is built into a synth then duplicating the
synth also duplicates the fx. Consider this patch with a trigger and a reverb. Run it and check
the cpu usage and number of Ugens in the server window. It's not too bad when running one
copy of the synth, but try six of them using Synth("inefficient") and watch the cpu and Ugens
increase with each one. (Note that since the trigger is random you might have to let it run a
while before you hear anything.)

And here is another trick for executing the same line of code several times: type
Synth("inefficient") at the bottom of a new window but don't type a return. Now when you
press enter the cursor won't go to the next line, but will stay on the Synth line. Each time you
press enter a new synth will be created.


inefficient patch
*/

(
SynthDef("inefficient",
{
var out, delay;
out =
	SinOsc.ar(LFNoise0.kr(15, 400, 800), mul: 0.2)
	*
	EnvGen.kr(
		Env.perc(0, 1),
		gate: Dust.kr(1)
	);

delay = CombC.ar(out, 0.5, [0.35, 0.5]);
out = Pan2.ar(out, Rand(-1.0, 1.0));
Out.ar(0, (out + delay))
}).play;
)

// Type this into a new window with no return and keep pressing enter
Synth("inefficient");

/*
If you run six versions you get six reverbs (CombC) and six triggers (Dust.kr). On my
machine that totals 96 Ugens and 16% of cpu. If we break up the patch so that the trigger,
source (SinOsc), and reverb (CombC) are all separate units then we can get virtually the same
effect using one trigger and one reverb.

more efficient modular approach using busses
*/

(
//define all the synths in one pass
SynthDef("singleTrigger", {
	Out.kr(
		//output busses are 1560 through 1565
		LFNoise0.kr(5, mul: 4.0, add: 1563).div(1),
		Dust.kr(6)
	)
}).add;

SynthDef("source",
{ arg trigIn, rate;
var out, delay;
out =
	SinOsc.ar(LFNoise0.kr(rate, 400, 800), mul: 0.1)
	*
	EnvGen.kr(
		Env.perc(0, 1),
		gate: In.kr(trigIn)
	);

out = Pan2.ar(out, Rand(-1.0, 1.0));
Out.ar(16, out)
}).add;

SynthDef("singleReverb",
{
var signal;
signal = In.ar(16, 2);
	Out.ar(0, (signal + CombC.ar(signal, 0.5, [0.35, 0.5])))
}).add;

)

// start the trigger
Synth("singleTrigger", [\rate, 1/4]);

// start the reverb
Synth("singleReverb");

// start the sources "watching" trigger busses 4-9
// start 4 and 9 first to make sure they're working (with
// a slow and fast rate so you can keep track)

Synth("source", [\trigIn, 1560, \rate, 4]);
Synth("source", [\trigIn, 1565, \rate, 25]);
Synth("source", [\trigIn, 1561, \rate, 10]);
Synth("source", [\trigIn, 1562, \rate, 8]);
Synth("source", [\trigIn, 1563, \rate, 17]);
Synth("source", [\trigIn, 1564, \rate, 7]);

/*
In this patch I first define a trigger that is playing on six busses: 1560 through 1565 (with a
little overlap). Why 1560s? because they can be anything. The LFNoise generates values
between 1559 and 1566, converted to integers with div(1) and is used to "spray" Out bus
numbers. (I'm not sure if this is clever or just a hack. It works.) Imagine busses 1560 through
1566 with leds lighting up one at a time as the LFNoise0 erratically jumps around between
them. They will act as triggers. When LFNoise0 "hits" one of the busses it sends a trigger to
that bus.

The source synth gets its trigger from a bus, set by the argument trigIn. When we launch
each copy of the source we assign it to "watch" one of the busses. When the LFNoise0 trigger
connects with, say, bus 1563, then the source that is listening to that bus will fire.
My machine shows 79 Ugens and 6%; half the cpu of the less efficient version.
When do you break a patch up into components? When would you not? In this case the
reverb is exactly the same. If you wanted each of the delay times to be different, i.e. if it is
critical to the composition that they be different (the practice example below might fall into
this category), then they should be part of the patch, so that each synth has a unique reverb.
But in this case, I believe that the CombC in all of the inefficient duplications are precisely
the same, with the same delay times, so it is worth separating that component and using just
one.

Groups

Hopefully by now you have tens or possibly hundreds of nodes running in a patch. It would
be difficult to manage the nodes and controls of each one individually. This is where groups
come in, because controls can be sent to an entire group. They also have an order in the
linked list and all the nodes in the group inherit the order of the group. All your sources could
be in a group that is "ahead" of a group containing filters. You wouldn't have to worry about
the position of each individual source and each filter. All of the filters in the group will be
after all sources if the filter group is after the source group.

Group Manipulation

A group could contain ten or so duplications of one synth that you would want to act in
unison. A message controlling amplitude, frequency, attack, decay, etc. sent to the group will
change all of its children (the individual synth defs) at once.


Groups, group manipulation
*/

(
//Create a synth
SynthDef("ping",
{arg fund = 100, harm = 1, rate = 0.2, amp = 0.1;
a = Pan2.ar(SinOsc.ar(fund*harm, mul: amp) *
EnvGen.kr(Env.perc(0, 0.2), gate: Dust.kr(rate)), Rand(-1.0, 1.0));
Out.ar(0, a)
}).add;
)

// Define a group using a global variable (~)
~synthGroup = Group.head(s);

// Run this 8 or so times, adding a new ping to the group
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
//etc.

// Change all the rates of the group
~synthGroup.set(\rate, 3/5);
~synthGroup.set(\rate, 8);

// Change the amplitude
~synthGroup.set(\amp, 0.2);
~synthGroup.set(\amp, 0.01);

//Command-period stops the synths and the group, so use this so that the
//group still exists.
~synthGroup.freeAll;

/*
All items in the group that have a rate or amp argument will recognize the change. If we had
added a synth that did not have those arguments, the command would be ignored.
I use global variables (identified with a tilde) for the synth groups.

The argument for Group.head is the target. Using .head means that this group is at the head
of its parent; the server. It could be added to another existing group, but this is the only one
we have, so it is added to the running server (which is the default group).  We add pings to
the group using Synth. We've used Synth to create new nodes before. They were added to the
default group without us knowing it. Now we are explicitly adding it to a group.

The last command, freeAll, is used rather than command-. because we want the group to
remain active even though we stop all the nodes.

The next example creates nodes using Array.fill, adding each to the group. This allows us to
use the arguments i to manipulate each harmonic as the synth is created. I could have used
12.do, but filling an array with the synths allows access to each one in the array. If I want to
change just one I can then use ~all.at(n).set(args).

I'm assuming the group is still active. If it isn't, run that line of code again before doing this
example.


Automated node creation
*/
(
~all = Array.fill(12,
	{arg i; Synth("ping", [\harm, i+1, \amp, (1/(i+1))*0.4],~synthGroup)});
)

~synthGroup.set(\rate, 0.8);
~synthGroup.set(\rate, 5);

Array.fill(12, {arg i; i/2+1})

// Change the amp of one node
~all.at(6).set(\amp, 1);
~all.at(6).set(\amp, 0.1);

// Change all the harmonics using a formula. I checked the formulas
// using this Array.fill(12, {arg i; i/2+1})

~all.do({arg node, count; node.set(\harm, count/2+1)}); //1, 1.5, 2, etc.
~all.do({arg node, count; node.set(\harm, count*2+1)}); //1, 3, 5, 7, etc.
~all.do({arg node, count; node.set(\harm, count*1.25+1)});
~all.do({arg node, count; node.set(\harm, count*1.138+1)});

// Change the fundamental
~synthGroup.set(\fund, 150);
~synthGroup.set(\fund, 250);
~synthGroup.set(\fund, 130);

// Stop the nodes but not the group
~synthGroup.freeAll;

// Create a task that adds new synths
(
r = Task({{Synth("ping",
	[\fund, rrand(100, 2000), \rate, 2], ~synthGroup); 1.wait}.loop}).play
)

// Slow down the attacks when it gets to be too many
~synthGroup.set(\rate, 0.2);

// Turn them all down. Note that new ones still have the old volume
~synthGroup.set(\amp, 0.01);

// Stop everything but the task
~synthGroup.free;

// Stop the t......ask
r.stop;

/*
Now we will add another group to the tail of the default group (the server) for all fxs. Note
that if I wanted to route the fx in series, that is source -> fx1 -> fx2, -> fx3, then I would need
to have them and/or their groups in the correct order. But here they are in parallel: the source
is routed to both echoes and both echoes are mixed to bus 0, 1.

I've changed the output bus for the ping to 16 in order to route it to the echoes. I send all the
definitions at once, create a source group for the pings and an fx group for the echoes. The
order of creation doesn't matter because their nodes are determined by the group; synthGroup
is at the head where it should be and fxGroup is at the tail. I can start and stop them in any
order.

There are actually going to be three "echoes" in the fx group. Two are echoes using Comb,
but in neither of those do I mix in the dry signal. So echo1 and echo2 are just the wet signal,
no source. I use a dry synth that just reroutes the source to bus 0 and 1 so that I can control it
separately, adding or removing it from the final mix. This could also have been done using
Out.ar([0, 1, 16, 17], a), routing the source to 16 and 17 for fx, 0 and 1 for the dry signal.

Source Group, Fx Group
*/

(
SynthDef("ping",
{arg fund = 400, harm = 1, rate = 0.2, amp = 0.1;
a = Pan2.ar(SinOsc.ar(fund*harm, mul: amp) *
EnvGen.kr(Env.perc(0, 0.2), gate: Dust.kr(rate)), Rand(-1.0, 1.0));
Out.ar(16, a)
}).add;

SynthDef("dry",
{var signal;
signal = In.ar(16, 2);
	Out.ar(0, signal);
}).add;

SynthDef("echo1",
{
var signal, echo;
signal = In.ar(16, 2);
echo = CombC.ar(signal, 0.5, [0.35, 0.5]);
	Out.ar(0, echo);
}).add;


SynthDef("echo2",
{
var signal, echo;
signal = In.ar(16, 2);
echo = Mix.arFill(3, { CombL.ar(signal, 1.0, LFNoise1.kr(Rand(0.1, 0.3), 0.4, 0.5),
15) });
	Out.ar(0, echo*0.2)
}).add;
)


~synthGroup = Group.head(s);
~fxGroup = Group.tail(s);

// 12.do will not allow me to access each one, but it doesn't matter
(
12.do({arg i;
	Synth("ping", [\harm, i+1, \amp, (1/(i+1))*0.4],
	~synthGroup)});
)

// "ping" is playing on bus 16, so we don't hear it

// Start the echo1 (wet), echo2 (still wet), then dry
a = Synth("echo1", target: ~fxGroup);
b = Synth("echo2", target: ~fxGroup);
c = Synth("dry", target: ~fxGroup);


b.free; // remove each in a different order
a.free;
c.free;

// The original ping is still running, so stop it.
~synthGroup.freeAll;

// This also works
a = Synth("echo1", target: ~fxGroup);
b = Synth("echo2", target: ~fxGroup);
12.do({arg i; Synth("ping", [\harm, i+1, \amp, (1/(i+1))*0.4],~synthGroup)});
c = Synth("dry", target: ~fxGroup);

~synthGroup.freeAll; // Stop the source, but the echoes are still running

// Start the source again
12.do({arg i; Synth("ping", [\harm, i+1, \amp, (1/(i+1))*0.4],~synthGroup)});

~synthGroup.set(\rate, 0.8);
~synthGroup.set(\rate, 5);

~synthGroup.free;
~fxGroup.free;

/*
Practice: Bells and Echoes

Bells and echoes
*/

(
SynthDef("bells",
{arg freq = 100;
var out, delay;
out = SinOsc.ar(freq, mul: 0.1)
*
EnvGen.kr(Env.perc(0, 0.01), gate: Dust.kr(1/7));

out = Pan2.ar(Klank.ar(`[Array.fill(10, {Rand(100, 5000)}),
	Array.fill(10, {Rand(0.01, 0.1)}),
	Array.fill(10, {Rand(1.0, 6.0)})], out), Rand(-1.0, 1.0));

Out.ar(0, out*0.4); //send dry signal to main out
Out.ar(16, out*1.0); //and send louder dry signal to fx bus

}).add;

SynthDef("delay1", // first echo
{var dry, delay;
dry = In.ar(16, 2);
delay = AllpassN.ar(dry, 2.5,
	[LFNoise1.kr(2, 1.5, 1.6), LFNoise1.kr(2, 1.5, 1.6)],
	3, mul: 0.8);
Out.ar(0, delay);
}).add;

SynthDef("delay2", // second echo
{var delay, dry;
dry = In.ar(16, 2);
delay = CombC.ar(dry, 0.5, [Rand(0.2, 0.5), Rand(0.2, 0.5)], 3);
Out.ar(0, delay);
}).add;

SynthDef("delay3", // third echo
{
var signal, delay;
signal = In.ar(16, 2);
delay = Mix.arFill(3, { CombL.ar(signal, 1.0, LFNoise1.kr(Rand([0.1, 0.1], 0.3), 0.4,
0.5), 15) });
	Out.ar(0, delay*0.2)
}).add;
)

//define groups
~fxGroup = Group.tail;
~bellGroup = Group.head;

// start one of the echoes and 4 bells
f = Synth("delay3", target: ~fxGroup);
4.do({Synth("bells", [\freq, rrand(30, 1000)], target: ~bellGroup)})

// stop existing echo and change to another
f.free; f = Synth("delay1", target: ~fxGroup);
f.free; f = Synth("delay2", target: ~fxGroup);
f.free; f = Synth("delay3", target: ~fxGroup);
Synth("delay1", target: ~fxGroup); // add delay1 without removing delay3

~bellGroup.free;
~fxGroup.free;






/*
Whew!
*/



