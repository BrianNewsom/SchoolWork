/*
MUSC 4121/5121					Spring 2013

Tutorial 1 (With examples from David Cottle's tutorial)


SuperCollider 3 - Introduction to the language and programming basics

Download SC 3 here:  http://supercollider.sourceforge.net//

NOTE: This tutorial refers to SC 3.5. The newest version, 3.6, has a completely redesigned
interface. Differences will be noted below. Most of the 3.5 code will run in 3.6.

A Brief Note About the Servers

"The name SuperCollider is in fact used to indicate five different things:
	1. an audio server
	2. an audio programming language
	3. an interpreter for the language, i.e. a program able to interpret it
	4. the interpreter program as a client for the server
	5. the application including the two programs and providing mentioned functionalities"

Think of SuperCollider having two separate and independent parts. The Server side, scsynth,
and the Client side, sclang. The Server is where the synthesis engine lives and it receives
messages from the Client via the Supercollider language (and OSC). If one component crashes, the other
side will not be effected.  For example, if sclang crashes, the server will keep making sound,
an important feature for live performance. If scsynth crashes, you can restart it from the client side.

You will notice that when SC launches two server windows open, a localhost and an internal
server. The difference between the two is that the localhost runs as a separate application with its own
address space, and the internal runs inside of the same space as the language/client
application. The internal server has the advantage of having less language latency and being able
to access shared memory so that things like scope windows can run. The localhost is more robust
and I recomend that it be used as your default server.

3.6 users - This version is an Integrated Developement Environment (IDE) and there is only one window
that contains the poet window, the help browser, and the code wondow. There is now only one server
window and it does not appear upon launch. To show this window, type:
*/
s = Server.local;
s.makeWindow;
/*
Place your cursor on the first line and hit shift-return, then do the same with the second line.
Also note that 3.6 files are saved as .scd files, not .rtf files

All users
SC Basics

When SC3 launches, a post window opens with information about the program. This window
will print useful information such as available audio drivers, the selected sample rate, errors, and results
of your code. You can also use this window to write code, but it is more efficient to open a new window for new code.

SuperCollider is a text editor (.rtf file types), programming language, compiler, and digital synthesizer.
This means you use SC to create and edit lines of code that contain instructions for making and playing
sounds. You can then use SC to evaluate and debug the code, compile or run the code, and the result
can be real time audio. The text editing functions (select, copy, replace, etc.) are similar to any basic
editor. But there are a few handy editing features that are unique to, and useful when editing code.
If you've never written code their value is not immediately apparent. So I suggest you come back and
review these often. (Com refers to command, the "Apple" key.)

Com-, 		Go to line number
Com-/		Make selected lines a comment
Opt-Com-/ 	Remove comment marks on selected lines
Shift-Com-B 	Balance enclosures
Com-] 		Shift code right
Com-[ 		Shift code left
Com-. 		Stop all playback
Com-d         Open help file for selected item
Com-' 		Syntax colorize
Double 		click enclosure Balance enclosures
Com-\ 		Bring post window to front
Shift-Com-K   Clear post window
Shift-Com-\   Bring all to front

Note that some .rtf files will open in Text Edit and will not open automatically in SuperCollider. Make sure you
open .rtf files containing SC code from within the SC application, or by right clicking the mouse
and choosing "open with". You can also right-click on the file and choose "Get Info", select "Open with",
and make SC the default.

Evaluation

Evaluation can result in either a message from the system about the code, or numbers (data)
resulting from the expression or functions (like a calculator), or sounds from a synthesizer
patch. The data from an SC patch could be pitches for transcription or instructions to the
performer or the results of analysis. But our short term goal will be sound.

To evaluate selected code you press the enter key (not return, but enter). If there is no enter key
(new Mac Books) type function - return. (fn - return) Or even easier, shift - return
If you want to evaluate a single line you don't need to select it, just position the cursor anywhere in the line.
To run the examples in this text, position the cursor anywhere within
the line or select all the lines and press enter.  3.6 users must use shift-return.

Also, you may have noticed that this text is red. That is because it is a comment and will not be evaluated
by the interpreter. Anything followed by // will be a comment. For large blocks of text, open with

/*

BLOCK OF TEXT

and close with
*/

Type the following lines into an SC window and evaluate them:

*/

"Hello World";

"Hello World".speak;

// For this example, select both lines:

"Warning! Warning! Self destruct sequence has begun. Sixty seconds to escape pod destruct.".speak;

/*
Note that each line is terminated with a semi-colon. This indicates the end of a line, or expression.
The following are some more meaningful examples.
*/

5 + 4;

5 + 4 * (5 - 4);

(5 + 4).asString.speak;

(440 * 3/2).asString.speak;

("The frequency for E5 is " ++ (440 * 3/2) ++ " Hertz".asString).speak;

("The frequency for middle C is " ++ (60.midicps.round(0.1)) ++ " Hertz".asString).speak;

/*
There is a good reason for calling this "code." Beginners find it cryptic. It is indeed a new
language, just like French or, maybe more apt, LatoocarfianN. But as languages go, smalltalk is
easy, and often reads like English. The parentheses mean either "here is a list of values to
use" or "do this first", and the quotations mean "this is a string, or text." The "dots" mean
"send this information to that object." And the ++ means "concatenate this text with the
next." Here is a translation of the last line in example above: Convert the MIDI number 60
into cycles per second (midicps), then round that value to 0.1, convert it to a string.
Concatenate that with "The frequency..." and then Concatenate that with "Hertz" and
speak the results.

SuperCollider is not synthsizing the speech, but is accessing the system speech synthesizer.
Following is some fun with Speech...
*/

(
Speech.init(16);
Task({
	16.do ({arg i;
		[0.1, 0.18, 0.2].choose.wait;
		Speech.setSpeechRate(i,[90, 30, 60].choose);
		Speech.setSpeechVolume(i,0.07);
		"help me, I am falling onto oblivian, wow".speak(i);
	});
}).play;
)

/*
To run an audio example we have to start the synth server, which actually makes the sound
based on commands written in code. Think of them as two rack-mounted synthesizers to which
you will send instrument definitions and playback instructions. Either server will work
for the examples in this text.

You only need to boot (i.e. power on) the server once for each session and leave it running.
This is done by either clicking the boot and default buttons on the user interface or by running
the line of code below. Some users prefer running the code because it names the server "s". Unless otherwise
indicated all the examples in this book will assume the server is running, that it is the default
server, and that it is called "s." Run, or "evaluate" the line below.
*/

Server.default = s = Server.local.boot;// localhost as default

Server.default = s = Server.interna;.boot;// internal as default

/*
Of course, you can start the servers by clicking on the Boot button. It is
important, though, to know which server is the default. Also note that the Scope will
only run if the internal server is running. (You can run both servers at the same time.)

This example is more complicated, with several lines of code. Later, we will learn what everything
means and how this code works. Select everything from the first curly-bracket  {  to and
including play and press enter. (To stop the playback type Com-.)
*/

{
 RLPF.ar(
  LFSaw.ar([8, 12], 0, 0.2),
  LFNoise1.ar([2, 3].choose, 1500, 1600),
  0.05,
  mul: 0.4
 )
}.play

/*
Error messages

One thing you will notice right away is that the compiler is very unforgiving about syntax,
spelling, and punctuation. Every comma, period, enclosure, upper and lower case, and semicolon needs
to be correct. If something is incorrect the program will print an error message in the post
window. Sometimes the error messages are hard to decipher. But one piece of information is
usually quite clear; it will indicate precisely where it broke down. Here is a typical error
message.


• ERROR: Parse error
   in file 'selected text'
   line 1 char 45 :
   {SinOsc.ar(LFNoise0.ar([10, 15], 400, 800), 0 0.3•)}.play
-----------------------------------
• ERROR: Command line parse failed

Parse error means that it didn't understand the code. The third line of the error message
tells you where in the file the error was encountered. In this case, line 1 char (character) 45
indicated by a "•." This is where the parsing failed. However, you usually have to look
carefully at the characters or lines just before the "•" to find the problem. The most common
errors are typos. In the above case, it is a missing comma.

The following is a very bad error message and the code police will be visiting you
early in the morning if you have too many of these:

ERROR: Message 'alcohol free' not understood.
RECEIVER:
Instance of Function {    (07DDAF80, gc=68, fmt=00, flg=00, set=01)
  instance variables [2]
    def : instance of FunctionDef - closed
    context : Frame (27A8340) of Interpreter:functionCompileContext
}
ARGS:
CALL STACK:
	DoesNotUnderstandError:reportError   09312FB0
		arg this = <instance of DoesNotUnderstandError>
	Nil:handleError   09312F50
		arg this = nil
		arg error = <instance of DoesNotUnderstandError>
	Thread:handleError   09312B90
		arg this = <instance of Thread>
		arg error = <instance of DoesNotUnderstandError>
	Object:throw   09312EF0
		arg this = <instance of DoesNotUnderstandError>
	Object:doesNotUnderstand   09312D10
		arg this = <instance of Function>
		arg selector = 'alcohol free'
		arg args = [*0]
	Interpreter:interpretPrintCmdLine   07D161D0
		arg this = <instance of Interpreter>
		var res = nil
		var func = <instance of Function>
		var code = "{SinOsc.ar}.alcohol free"
		var doc = <instance of CocoaDocument>
	Process:interpretPrintCmdLine   09312AD0
		arg this = <instance of Main>

This was a CALL STACK error. Often it is a result of misspelling the object message. There
are many other reasons for this type of error and the key is snooping around the error message
and trying to figure out what you did wrong.

Evaluate the following line and then fix the errors.
*/

 {SinOsc.ar(LFNoise0.ar(10, 15] 400, 800), 0, 0.3)}.play //broken

/*
Objects, messages, arguments, variables, functions, and arrays

It is essential that you learn to identify these elements in code examples.

Objects
Actually, everything in SC is an object, but for the next few
chapters we will focus on those that are upper case words, numbers,
bracketed or braced items, and quoted text: Synth, SinOsc, LFNoise,
EnvGen, 5, 6.7, "string", etc.

Messages
These usually follow objects separated by a dot (.): play, scope,
ar, kr, max, rand, midicps. (But also see functional notation below.)
Note, that in SC messages are polymorphic, meaning that different
classes can respond to the same message in a manner that is
unique to that class. See the Polymorphism help file for more
information.

Arguments
A list of items separated by commas, enclosed in parentheses,
following a message:
(1, 2, 4), ("string", 45, myVar),  ({function}, 0.1, [1, 2, 3])

Variables
User defined names of memory locations, beginning with lower case,
but often words strung together with caps in the middle: pitchClass,
nextCount, freqArray, myVar, a, s, etc. Note that in SuperCollider the
lower case letters a to z are reserved as variable names and do not
need to be declared but only defined.

Enclosures
Matching parentheses, brackets, and braces, that define
arguments lists,  functions, and arrays: (0, 100, 555), {arg next; next = 100},
[100, 200, 500]  - see more below.

Functions
Anything enclosed in braces: {arg next; next = 100}, {possibly many
pages of code}, {SinOsc.ar(60.midicps)}

Arrays
A list of items separated by commas, enclosed in brackets:
[1, 2, 3], ["C", "D"], [a, b, c]

Expression
A line of code punctuated by a semicolon.

Ugens
Unit generators are a combination of object, message, and argument
list that result in some type of output. Ugens are connected
together to create a patch: LFNoise0.ar(0.5), SinOsc.ar(440, 0,
0.4), Sequencer.ar(s, r, j)

Enclosures (parentheses, braces, brackets)

Enclosures are used to group things together and indicate the order of execution. Each
opening parenthesis, bracket, and brace has a matched closing parenthesis, bracket, and
brace. After you've programmed for a while you get used to matching up enclosures. The
compiler runs or evaluates the code from the inner most matching enclosures, then works
outward. If you don’t have matching enclosures you will get an error message. When items
are nested you often will see six or seven open enclosures as you read left to right, then all of
the closing enclosures later in that line, as illustrated below.  Notice that the inner most matching
enclosure is the array [12,15].
*/

{Saw.ar(Pulse.ar(max(rrand([12,15],5)),400,800),0,0.3)}.play //this doesn't make sound

/*
One method for clarifying the matching enclosures is to indent each new level, as shown in
example below. Matching enclosures should be on the same level of indentation. Often the
opening enclosure is included on the same line as its associated object message combination.
*/

{ // 1
 SinOsc.ar
 ( // 2
  LFNoise0.ar
  ( // 3
    100, 400, 800
  ), // 3
  0, 0.3
 ) // 2
} // 1
.play

// Or

{ // 1
 SinOsc.ar( // 2
  LFNoise0.ar( // 3
    100, 400, 800
  ), // 3
  0, 0.3
 ) // 2
} // 1
.play

/*
Pressing Shift-Com-B or double clicking on any enclosure is another way to quickly see
matched sets. SC will shade everything within matching enclosures. To see how this works,
place the cursor in any example and repeatedly press Shift-Com-B.

Look again at the examples above and practice identifying each of the items we've discussed.
I'll do the first one: The objects are SinOsc, LFNoise0, the function, and all the numbers. The
messages are play and ar. Functions and arguments are a little harder to spot.  All of the text
{SinOsc ... 0.3)} is a function (everything between { and }). Arguments can be hard to see if
they are nested.  The way you spot them is to look for a message such as .ar followed by an
opening parenthesis. All the items between that opened parenthesis and the matching closing
one are the arguments. In the code LFNoise0.ar(10, 400, 800) the .ar is the message, so (10,
400, 800) is a list of three arguments for the ar message.

Arguments

Arguments represent control parameters. They are similar in function to the knobs on an analog
synthesizer that change frequency range, filter cutoff, amplitude, sequencer speed, etc. You
can think of arguments as the value a knob would point to.

Take the following patch as an example. The arguments for LFNoise0.ar are (10, 400, 800).
Change these three values and run the code to see how they change the sound. Try 15, 25, 30,
or 40 for the first argument. Try 100 and 700, 30 and 100, 1600 and 1700 for the second two
arguments.
*/

{SinOsc.ar((LFNoise0.ar(10, 400, 800)).abs, 0, 0.3)}.play

/*
How do you know what the arguments represent, or how they affect the sound? The first step
is to look up the help file. Most objects have help files. To read a help file you highlight the
item you want help with and press Com-d . See also Com-j. Com-y, and the "More on Getting Help"
help file. Once a help file is open I also use Com- click on the title bar to open the folder it is in to see
related help topics.  More on the help files below.

Now that we've identified the arguments for LFNoise0.ar, what are the arguments for the ar
message that follows SinOsc? They are all enclosed in the parentheses following the
SinOsc.ar. Notice that the first argument for this list is all the code we were just looking at in
the previous example; LFNoise0.ar(10, 400, 800). The second argument is 0, and the third
argument is 0.3. (Notice the decimal aka floating point or just float is preceded by a zero so
that it is not confused as a message.)  So the arguments for LFNoise0.ar are combined with
LFNoise0.ar as the first argument for SinOsc.ar. This is called nesting. LFNoise0.ar(10, 400, 800)
is nested in the argument list for SinOsc.ar. There is also a .abs message being sent to the LFNoise0.
This tells LFNoise to generate only absolute numbers.

There is one more object and message to identify. The function is an object and play is the
message.

Sandwich.make

The terminology of object oriented languages is more difficult because the object names and
messages are often cryptic acronyms (Synth, PMOsc, LFNoise0, midicps, rrand, etc.). So we'll
use familiar fictitious objects and messages to explain how they work. (These examples
won't work in SC but try them in Chef http://www.dangermouse.net/esoteric/chef.html)

Suppose we had a virtual sandwich maker and a virtual tofu based meat substitute both of
which understood smalltalk commands. I'll call these fictitious objects Sandwich and Tofu.

Every object understands a collection of messages. The messages tell the object what to do.
Likewise, there are many objects that understand any given message. SuperCollider is
polymorphic when it comes to messages. Polymorphism lets you write code that doesn't
assume anything about the implementation of an object. Instead, it asks the object to
"do what I mean" and have the object respond approriately. The power of object-
oriented languages lies in the way you can mix and match messages and objects.

For example, let's assume that Sandwich understands three messages: make, cut, and bake.
And that Tofu understands three messages: bake, fry, and marinate. The syntax for sending
the make message to the Sandwich might be this:

Sandwich.make;

If you wanted the Tofu to be baked you might write:

Tofu.bake;

You may be wondering if we need to give the make message and the bake message some
arguments to describe how the sandwich is made and the tofu is baked. Actually we don't.
Most messages have default values built into the code so you can leave them off provided the
defaults are appropriate for your project. Try running the lines in the next example, which uses no
arguments in the .ar or .play messages, in SC. Next run the second example with an argument list for
both ar and play. (Press command-period to stop.)
*/

{SinOsc.ar}.play

/*
The first result is a sine tone at 440 Hz, 1.0 amplitude, at 0 phase.

To find the defaults for an object, highlight the object and type Com-j and you will get the following:

SinOsc : UGen {
	*ar {
		arg freq=440.0, phase=0.0, mul=1.0, add=0.0;
		^this.multiNew('audio', freq, phase).madd(mul, add)
	}
	*kr {
		arg freq=440.0, phase=0.0, mul=1.0, add=0.0;
		^this.multiNew('control', freq, phase).madd(mul, add)
	}
}

To find the help file for an object, highlight the object and type com-d:


SinOsc			interpolating sine wavetable oscillator

SinOsc.ar(freq, phase, mul, add)

Sinusoidal oscillator; a sine tone.

Note: This is the same as Osc except that the table has already been fixed as a sine table of 8192 entries.

freq - frequency in Hertz
phase - phase offset or modulator in radians


*/

{SinOsc.ar(800, 0, 0.1)}.play(s, 0, 10)

/*
The example above uses messages to get a different result from SinOsc.
Here the argumets are for a frequency of 800, phase of 0 and a mul of 0.1,
played on server "s", output bus 0, with a 10 second fade time.  Often you
are able to use one or two of the defaults, but rarely will you use a message
with defaults only.

Before adding arguments we need to know what each of them means. To find out you use the
help files.

In each of the help files are prototypes of all the messages understood by that object, with the
list of arguments the message uses. Sandwich and Tofu might be documented this way:

Sandwich

*make(vegArray, bread, meat)
*cut(angle, number)
*bake(temp, rackLevel)

Tofu

 *bake(temp, baste, rackLevel)
 *fry(temp, length, pan, oil)
 *marinate(sauce, time)

It is important to understand that the argument list changes for different objects. That is to
say the bake message used with Sandwich has two arguments, while when used with Tofu it
has three. Not understanding this, and using the same arguments with a message to different
objects is a common beginner error. When bake is used with Sandwich, as in
Sandwich.bake(20, 2) the 2 is rack level, while in Tofu.bake(20, 2) the 2 is baste time.
Remember; argument lists are not interchangeable between objects.

Now that we understand what the arguments for Sandwich.make are, we could put together a
Sandwich with this mock code.

Sandwich.make([lettuce, tomato, pickle], rye, chicken)

or

Sandwich.cut(90, 1)

and

Tofu.marinate(peanut, 160)

The first line will make the Sandwich using an array (list) of vegetables, bread, and chicken.
The second line will make one cut of the Sandwich at an angle of 90 degrees. The Tofu will
be marinated with peanut sauce for 160 minutes.

Another powerful aspect (the whole point, really) of SC and object oriented languages is that
everything is an object, and you can substitute them freely. Instead of chicken as the third
argument I could use the nest the entire section of Tofu code.

Sandwich.make([lettuce, tomato, pickle], rye, Tofu.marinate(peanut, 160))

The second argument in marinate could be replaced with rrand(20, 100), which chooses a
value between 20 and 100.

Sandwich.make(
 [lettuce, tomato, pickle],
 rye,
 Tofu.marinate(peanut, rrand(20, 100))
)

When a program evaluates the code it begins with the inner most parts, and uses the results of
those values to run the subsequent outer layers. In English, the example above might read
like this: Marinate tofu in peanut sauce for some value between 20 and 100. After marinating
the tofu, use it as the meat (third argument) for a sandwich with lettuce, tomato, and pickle,
on rye bread.

It is possible to link messages. For example Sandwich.make.bake.cut would first make the
sandwich (in this case using defaults), then bake it (using defaults), then cut it (with defaults).
One object can be used as an argument for another instance of the same object. For example,
you could write Tofu.marinate(Tofu.marinate(peanut, 60), 60). In this case, a batch of tofu
will be marinated in peanut sauce for 60 minutes, then another batch of tofu will be
marinated in that batch of marinated tofu.

Simple Examples

Following are some very simple examples first without comments, then with comments.
*/

(
{SinOsc.ar(220, 0, 0.5, 0)}.play
)

//commented

( 			  // opening parens for block selection
	{      	  // curly bracket for begining of a function
	SinOsc.ar  // sine wave oscillator with audio rate message
		(        // opening parens for argument list
		220,   // frequency arg followed by a comma
		0,      // phase arg
		0.5,   // multiply arg
		0       // add arg, no comma after last argument
		)        // matching closing parens for argument list
	}.play        // Matching closing curly bracket and play message for the function
)			  //closing parens for block selection


//same patch, but with two channels and a scope
(
{SinOsc.ar([220, 280], 0, 0.5, 0)}.scope
)

//with comments
( 			  // opening parens for block selection
	{      	  // curly bracket for begining of a function
	SinOsc.ar  // sine wave oscillator with audio rate message
		(        // opening parens for argument list
		[220, 280],  // frequency arg in square brackets for multi channel expansion
		0,      // phase arg
		0.5,   // multiply arg
		0       // add arg, no comma after last argument
		)        // matching closing parens for argument list
	}.scope        // Matching closing curly bracket and scope message for the function
)			  //closing parens for block selection



/*
Getting Help

You will notice that in the Help pull down menu there are four SuperColider specific options:
SuperCollider Help, Browse Search and Documentation, Class Browser, and Help Tree. The
SuperCollider Help will open a window with many links to various topics ranging from listing all
the Ugens to describing how to create standalone apps. The Browse Search and Documentation
will open a window with a field where you can type a word or symbol and search all the help files.
The Class Browser opens a window that allows one to view "under the hood" the various methods
implementations, etc., of all the calsses in SC (more for advanced users). The Help Tree is a
handy way of accessing the help files.

You will want to look at as much code as possible, and a good place to start are the examples files
found in the SuperCollider folder located in Applications. There is also a folder with the help files
located here. As you look at code you will discover that there are many ways to write the same
code and that there are many syntax shortcuts and symbolic notations that can be very confusing
for the SC newbie. You have been warned...

Experimenting With a Patch

Below are two patches. Read the help files associated with each object. You may not
completely understand all the terms, such as mul and add, and how they affect the patch, but
it's ok to suppress some questions and be satisfied with what you do know. For now let's say
the LFNoise0 is generating values between 400 and 1200 10 times per second. How does this
fit into the entire patch? Look at the documentation for SinOsc and you will see that the first
argument is freq. The entire LFNoise0.ar(etc.) is being used as the freq argument in the
SinOsc. To confirm this, try replacing the LFNoise0.ar(10, 400, 800). with a static value such
as 300. In this case you will hear a single pitch, 300 Hz.

Look at the help documentation for the second patch. See if you can make sense of the
arguments in relation to the actual sound. Try to predict how the changes you make will
change the sound before you run the code. Be very careful of the mul argument, you can
damage your ears! also note, in the second patch there is a balanced parentheses enclosing
 the entire patch. Double click after the first open parentheses and the entire block of code will
 be selected.
 */
{SinOsc.ar((LFNoise0.ar(10, 400, 800).abs), 0, 0.3)}.play

// the same patch with a short hand for sending the abs message
{SinOsc.ar(abs(LFNoise0.ar(10, 400, 800)), 0, 0.3)}.play

////////////

(
{
 RLPF.ar(
  LFSaw.ar([8, 12], 0, 0.2),
  (LFNoise1.ar([2, 3].choose, 1500, 1600).abs),
  0.05
 )
}.play
)

/*
The LFSaw in the second patch uses an array ([8, 12]) as the freq argument. The first value is
used for the left channel, the other for the right (more on this later). The LFNoise1 is
generating values that are used used as a cutoff in the RLPF (resonant low
pass filter). The LFSaw is the input frequency.

Feel free to experiment. Here is one of the reasons I like to teach with SC. When working
with the old analog synthesizers, entering incorrect values or making patching errors (e.g.
outs to outs) could actually damage the equipment. But in SC you can try just about anything.
There is indeed a danger of crashing the machine or getting error messages or possibly
damaging your ears if the sound is too loud. But otherwise you can experiment at will.

Here is another nice thing about working with code: It is self-documenting. If you make
changes that result in an interesting sound you can easily save it to a file. To do this choose
Save As and name the file or copy and paste the patch into a new file. Experiment with the
patch below.

Just for fun, try these UGens: MouseX.kr & MouseY.kr

Look them up in the help files to see the appropriate arguments and then plug them into
the code below.

*/

// select everything between the two outer parentheses by double clicking after
//the first one (find that sweet spot):

(
{
 CombN.ar(
   SinOsc.ar(
     LFNoise1.kr( // .kr means control rate
         4, // LFO
        24, // range in MIDI
           LFSaw.kr(
                [8,7.23],//second LFO
                 0,
                 3, // range in MIDI
                 80 // offset in MIDI
                    )
                  ).midicps,  //convert MIDI numbers to cycles per second
                 0,
                 0.04
            ),
        0.2, // max delay
        0.2, // actual delay
        4 // decay
       )
}.play
)



 /////////////

 (
{BPZ2.ar(
	WhiteNoise.ar(
		LFPulse.kr(
			LFPulse.kr(0.09, 0, 0.16, 10, 7),
		0, 0.25, 0.1)
		)
	)
}.play
)

//Stereo

(
{
Pan2.ar(
	BPZ2.ar(
		WhiteNoise.ar(
			LFPulse.kr(
				LFPulse.kr(0.09, 0, 0.16, 10, 7),
			0, 0.25, 0.1)
			)
		),
	SinOsc.ar(0.05, 0, 0.5, 0))
}.play
)


//// an advanced example

(
// police state
var n;
n = 4;	// number of sirens
play({
	CombL.ar(
		Mix.arFill(n, {
			Pan2.ar(
				SinOsc.ar(
					SinOsc.kr(0.1.rand + 0.02, 2pi.rand, 600.rand, 1000 + 300.rand2),
					0,
					LFNoise2.ar(100 + 20.0.rand2, 0.1)
				),
				1.0.rand2
			)
		})
		+ LFNoise2.ar(LFNoise2.kr([0.4,0.4], 90, 620), LFNoise2.kr([0.3,0.3], 0.15, 0.18)),
		0.3, 0.3, 3)
})
)

///

//////////////////////////////////////////////////////////////////////////

(
// what was I thinking?
{
	z = RLPF.ar(
		Pulse.ar(
			max( SinOsc.kr(4, 0, 1, 80),
				Decay.ar(LFPulse.ar(0.1, 0, 0.05, Impulse.ar(8, 0, 500)), 2)
			),
			LFNoise1.kr(0.157, 0.4, 0.5),
			0.04),
		LFNoise1.kr(0.2, 2000, 2400),
		0.2);
	y = z * 0.6;
	z +  [
			  CombL.ar(y, 0.06, LFNoise1.kr(0.3.rand, 0.025, 0.035), 1)
			+ CombL.ar(y, 0.06, LFNoise1.kr(0.3.rand, 0.025, 0.035), 1)
		,
			  CombL.ar(y, 0.06, LFNoise1.kr(0.3.rand, 0.025, 0.035), 1)
			+ CombL.ar(y, 0.06, LFNoise1.kr(0.3.rand, 0.025, 0.035), 1)
		]
}.play;
)

/*

Which font should you use?

I use Monaco for my code. I have a typing problem with 0 and O and when I make this error, it is
sometimes hard to see right away. But if when using Monaco 0 and O look quite different.

*/


/*
3.6 users ignore this:
Here is some of my startup file's content:
change the appearance of the post window

Copy the following text into a new window and name it startup.rtf
Put the file into the following plce:

YourUserName/Library/Application Support/SuperCollider

If you are using a CAML computer you will need to launch SuperCollider
then quit, put the file into the SC folder in application support, then
relaunch SC.
*/

Document.listener.background = Color(0, 0, 0, 0.95);
Document.listener.stringColor = Color(1, 1, 1, 1);
Document.postColor_(Color(0.2, 0.7, 0.3));
Document.listener.bounds = Rect(0, 545, 690, 635); // right-hand side of the screen








