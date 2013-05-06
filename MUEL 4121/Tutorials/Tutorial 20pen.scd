/*
More GUI Fun!

Pen

The Pen class allows the user to draw on an SCWindow. The methods described here need to be
called within an SCWindow-drawHook or a SCUserView-drawFunc. The results will be visible only
after the window or view is refreshed and each call to refresh will overwrite all previous drawing.

See also: Window, UserView, Color, and String

There are many methods available in this class and they include:

	*moveTo (point)
		Move the Pen to point. point is an instance of Point.

	*lineTo (point)
		Draw a line (define a path) from the current position to point. point is an instance of Point.

	*line (p1, p2)
		Draw a line (define a path) from p1 to p2. Current position will be p2. p1 and p2 are instances of Point.

	*stroke
		outline the previous defined path.


The follwing example will draw a line in a window that has a predetermined lemgth, color, and
position.

*/

(
		w = Window.new.front;
		w.view.background_(Color.white);
		w.drawHook = {
			// set the Color
			Pen.strokeColor = Color.blue(0.5, 0.5);
			Pen.translate(200,100);
			Pen.width = 10;
			// you have to set a starting point...
			Pen.moveTo(0@0);

			Pen.lineTo(1@100);
						Pen.stroke
		};
		w.refresh;
		)




/*
Make a shape

*/
		(
		w = Window.new.front;
		w.view.background_(Color.blue);
		w.drawHook = {
			// set the Color
			Pen.strokeColor = Color.red;
			Pen.moveTo(200@100);

			Pen.lineTo(250@200);
			Pen.lineTo(300@200);
			Pen.lineTo(200@250);
			Pen.lineTo(100@200);
			Pen.lineTo(150@200);
			Pen.lineTo(200@100);

			Pen.stroke
		};
		w.refresh;
		)

/*
Fill the shape with a color
*/

(
		w = Window.new.front;
		w.view.background_(Color.blue);
		w.drawHook = {
			// set the Color
			Pen.fillColor = Color.red;
			Pen.moveTo(200@100);

			Pen.lineTo(250@200);
			Pen.lineTo(300@200);
			Pen.lineTo(200@250);
			Pen.lineTo(100@200);
			Pen.lineTo(150@200);
			Pen.lineTo(200@100);

			Pen.fill
		};
		w.refresh;
		)

/*
Make a shape and a GUI controller to skew the shape.

*matrix_ (array)
		transforms coordinate system.
		array = [a, b, c, d, x, y]
			a	zoomX
			b	shearingY
			c	shearingX
			d	zoomY
			x	translateX
			y	translateY

*/


		(
		var controlWindow, w;
		var r, a, b, c, d, matrix = [1, 0, 0, 1, 10, 10];
		var sliders, spex, name;

		w = Window.new.front;
		w.view.background_(Color.white);

		// create a controller-window
		controlWindow = Window("matrix controls", Rect(400,200,350,120));
		controlWindow.front;

		// determine the rectangle to be drawn
		r = Rect.fromPoints(a = 0 @ 0, c = 180 @ 180);
		b = r.leftBottom;
		d = r.rightTop;

		// the drawHook
		w.drawHook = {
			Pen.strokeColor = Color.red;
		    	Pen.matrix = matrix;
		    	Pen.width = 5;
		    	Pen.strokeRect(r);
		    	Pen.strokeOval(r);
			Pen.color = Color.blue;
		    	Pen.width = 0.1;
		    	Pen.line(a, c);
		    	Pen.line(b, d);
		    	Pen.stroke;

		    Pen.font = Font( "Helvetica-Bold", 12 );
		    Pen.stringAtPoint( "A", a - 6 );
		    Pen.stringAtPoint( "B", b - 6 );
		    Pen.stringAtPoint( "C", c - (0@6) );
		    Pen.stringAtPoint( "D", d - (0@6) );

		    Pen.font = Font( "Helvetica", 10 );
		    Pen.stringInRect( "a matrix test", r.moveBy( 50, 50 ));
		};

		controlWindow.view.decorator = sliders = FlowLayout(controlWindow.view.bounds);
		spex = [
			[0, 2.0].asSpec,
			[0, 2.0].asSpec,
			[0, 2.0].asSpec,
			[0, 2.0].asSpec,
			[0, 200.0].asSpec,
			[0, 200.0].asSpec
		];
		name = #[zoomX, shearingY, shearingX, zoomY, translateX, translateY];
		6.do { |i|
		    EZSlider(controlWindow, 300 @ 14, name[i], spex[i], { |ez| var val;
		            val = ez.value;
		            [i, val.round(10e-4)].postln;
		            matrix.put(i, val);
		            w.refresh; // reevaluate drawHook function
		  	}, matrix[i]);
		  	sliders.nextLine;
		};
		w.refresh;
	)

/*
Redraw a pattern randomly.
*/

(
var w, run = true;
w = Window("my name is... panel", Rect(128, 64, 800, 800));
w.view.background = Color.white;
w.onClose = { run = false; };
w.front;
w.drawHook = {
	Pen.use {
		Pen.width = 0.2;
		400.do {
			Pen.beginPath;
			Pen.moveTo(Point(10.rand * 80 + 40, 10.rand * 80 + 40));
			Pen.lineTo(Point(10.rand * 80 + 40, 10.rand * 80 + 40));
			Pen.stroke;
		};
	};
};

{ while { run } { w.refresh; 1.0.rand.wait } }.fork(AppClock)

)

(
var w, run = true;
w = Window("my name is... panel", Rect(128, 64, 800, 500));
w.view.background = Color.white;
w.onClose = { run = false; };
w.front;
w.drawHook = {
	Pen.use {
		Pen.width = 2;
		80.do {
			Pen.width = rrand(0,4) + 0.5;
			Pen.beginPath;
			Pen.moveTo(Point(800.rand, 500.rand));
			Pen.lineTo(Point(800.rand, 500.rand));
			Pen.stroke;
		};
	};
};

{ while { run } { w.refresh; 1.0.rand.wait } }.fork(AppClock)

)

/*
Create an animation.
*/


// Animation

// Uses random seed to 'store' data
// By reseting the seed each time the same random values and shapes are generated for each 'frame'

// These can then be subjected to cumulative rotation, etc., by simply incrementing the phase var.
(
// By James McCartney
var w, h = 700, v = 700, seed, run = true, phase = 0;
w = Window("wedge", Rect(40, 40, h, v), false);
w.view.background = Color.rand(0,0.3);
w.onClose = { run = false }; // stop the thread on close
w.front;
// store an initial seed value for the random generator
seed = Date.seed;
w.drawHook = {
	Pen.width = 2;
	Pen.use {
		// reset this thread's seed for a moment
		thisThread.randSeed = Date.seed;
		// now a slight chance of a new seed or background color
		if (0.006.coin) { seed = Date.seed; };
		if (0.02.coin) { w.view.background = Color.rand(0,0.3); };
		// either revert to the stored seed or set the new one
		thisThread.randSeed = seed;
		// the random values below will be the same each time if the seed has not changed
		// only the phase value has advanced
		Pen.translate(h/2, v/2);
		// rotate the whole image
		// negative random values rotate one direction, positive the other
		Pen.rotate(phase * 1.0.rand2);
		// scale the rotated y axis in a sine pattern
		Pen.scale(1, 0.3 * sin(phase * 1.0.rand2 + 2pi.rand) + 0.5 );
		// create a random number of annular wedges
		rrand(6,24).do {
			Pen.color = Color.rand(0.0,1.0).alpha_(rrand(0.1,0.7));
			Pen.beginPath;
			Pen.addAnnularWedge(Point(0,0), a = rrand(60,300), a + 50.rand2, 2pi.rand
				+ (phase * 2.0.rand2), 2pi.rand);
			if (0.5.coin) {Pen.stroke}{Pen.fill};
		};
	};
};

// fork a thread to update 20 times a second, and advance the phase each time
{ while { run } { w.refresh; 0.05.wait; phase = phase + 0.01pi;} }.fork(AppClock)

)

(
var w, phase = 0, seed = Date.seed, run = true;
w = Window("my name is... panel", Rect(128, 64, 800, 800));
w.view.background = Color.blue(0.4);
w.onClose = { run = false; };
w.front;
w.drawHook = {
	Pen.use {
		if (0.02.coin) { seed = Date.seed; };
		thisThread.randSeed = seed;
		Pen.strokeColor = Color.white;
		200.do {
			var a = 4.rand;
			var b = 24.rand;
			var r1 = 230 + (50 * a);
			var a1 = 2pi / 24 * b + phase;
			var r2 = 230 + (50 * (a + 1.rand2).fold(0,3));
			var a2 = 2pi / 24 * (b + (3.rand2)).wrap(0,23) + phase;
			Pen.width = 0.2 + 1.0.linrand;
			Pen.beginPath;
			Pen.moveTo(Polar(r1, a1).asPoint + Point(400,400));
			Pen.lineTo(Polar(r2, a2).asPoint + Point(400,400));
			Pen.stroke;
		};
		thisThread.randSeed = Date.seed;
		40.do {
			var a = 4.rand;
			var b = 24.rand;
			var r1 = 230 + (50 * a);
			var a1 = 2pi / 24 * b + phase;
			var r2 = 230 + (50 * (a + 1.rand2).fold(0,3));
			var a2 = 2pi / 24 * (b + (3.rand2)).wrap(0,23) + phase;
			Pen.width = 0.2 + 1.5.linrand;
			Pen.beginPath;
			Pen.moveTo(Polar(r1, a1).asPoint + Point(400,400));
			Pen.lineTo(Polar(r2, a2).asPoint + Point(400,400));
			Pen.stroke;
		};
	};
};

{ while { run } { w.refresh; 0.1.wait; phase = phase + (2pi/(20*24)) } }.fork(AppClock)

)


(
var w, h = 800, v = 600, seed = Date.seed, phase = 0, zoom = 0.7, zoomf = 1, run = true;
w = Window("affines", Rect(40, 40, h, v));
w.view.background = Color.blue(0.4);
w.onClose = { run = false };
w.front;
w.drawHook = {
	thisThread.randSeed = Date.seed;
	if (0.0125.coin) { seed = Date.seed; phase = 0; zoom = 0.7; zoomf = exprand(1/1.01, 1.01); }
	{ phase = phase + (2pi/80); zoom = zoom * zoomf; };
	thisThread.randSeed = seed;
	Pen.use {
		var p1 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var p2 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var xscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var yscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var xlates = { 8.rand2 } ! 2;
		var ylates = { 8.rand2 } ! 2;
		var rots = { 2pi.rand + phase } ! 2;
		var xform;
		xscales = (xscales ++ (1/xscales)) * 1;
		yscales = (yscales ++ (1/yscales)) * 1;
		xlates = xlates ++ xlates.neg;
		ylates = ylates ++ xlates.neg;
		rots = rots ++ rots.neg;
		xform = {|i| [xlates[i], ylates[i], rots[i], xscales[i], yscales[i]] } ! 4;
		Pen.strokeColor = Color.grey(1,0.5);
		Pen.width = 8.linrand + 1;
		Pen.translate(400, 400);
		Pen.scale(zoom, zoom);
		Pen.translate(-400, -400);
		1200.do {
			var p, rot, xlate, ylate, xscale, yscale;
			Pen.width = 8.linrand + 1;
			Pen.beginPath;
			#rot, xlate, ylate, xscale, yscale = xform.choose;
			Pen.translate(xlate, ylate);
			Pen.rotate(rot, h/2, v/2);
			Pen.scale(xscale, yscale);
				Pen.moveTo(p1);
				Pen.lineTo(p2);
			Pen.stroke;
		};
	};
};

{ while { run } { w.refresh; 0.05.wait; } }.fork(AppClock)

)

/*
Now, add sound to play with your window.
*/

(
var w, run = true;
w = Window("spasm", Rect(0, 210, 1678, 1800));
w.view.background = Color.black;
w.onClose = { run = false; };
w.front;
w.drawHook = {
	Pen.use {
		Color.rand.set;
		Pen.width = 0.2;
		300.do {
			Pen.width = rrand(0,0.5) + 0.1;
			Pen.beginPath;
			Pen.moveTo(Point(20.rand * 80 + 40, 12.rand * 80 + 40));
			Pen.lineTo(Point(22.rand * 60 + 40, 10.rand * 50 + 40));
			Pen.stroke;
		};
	};
};

{ while { run } { w.refresh; 0.01.rand.wait } }.fork(AppClock)

+

{
var triggerSpeed, trigger, in;

triggerSpeed = 8;
trigger = Impulse.kr(triggerSpeed);
in =
	Pulse.ar(
 		TRand.kr(30, 100, trigger),
 			mul: EnvGen.kr(
  		Env.perc(0.001, 1/triggerSpeed),
  trigger
 )
);
Pan2.ar(in, LFNoise1.ar(8))

+

 RLPF.ar(
  LFSaw.ar([8, 12], 0, 0.2),
  LFNoise1.ar([2, 3].choose, 1500, 1600),
  0.05,
  mul: 0.4
 )
}.play
)


(
var w, run = true;
w = Window("spasm", Rect(0, 210, 1678, 1800));
w.view.background = Color.black;
w.onClose = { run = false; };
w.front;
w.drawHook = {
	Pen.use {
		Color.rand.set;
		Pen.width = 0.2;
		3.do {
			Pen.width = rrand(0,165.5) + 0.1;
			Pen.beginPath;
			Pen.moveTo(Point(20.rand * 80 + 40, 12.rand * 80 + 40));
			Pen.lineTo(Point(22.rand * 60 + 40, 10.rand * 50 + 40));
			Pen.stroke;
		};
	};
};

{ while { run } { w.refresh; 0.01.rand.wait } }.fork(AppClock)

+

{
var triggerSpeed, trigger, in;

triggerSpeed = 8;
trigger = Impulse.kr(triggerSpeed);
in =
	Pulse.ar(
 		TRand.kr(30, 100, trigger),
 			mul: EnvGen.kr(
  		Env.perc(0.001, 1/triggerSpeed),
  trigger
 )
);
Pan2.ar(in, LFNoise1.ar(8))

+

 RLPF.ar(
  LFSaw.ar([8, 12], 0, 0.2),
  LFNoise1.ar([2, 3].choose, 1500, 1600),
  0.05,
  mul: 0.4
 )
 }.play
)

//////////////SPaCE PeN------>


(
var e, f, w, h = 1678, v = 1800, seed = Date.seed, phase = 0, zoom = 0.7, zoomf = 1, run = true;
e = Env.linen(2, 5, 2);
f = Env.linen(3, 8, 4);
g = Env.linen(4, 12, 6);
w = Window("spacePen", Rect(0, 210, h, v));
w.view.background = Color.black(0.4);
w.onClose = { run = false };
w.front;
w.drawHook = {
	thisThread.randSeed = Date.seed;
	if (0.0125.coin) { seed = Date.seed; phase = 0; zoom = 0.7; zoomf = exprand(1/1.01, 1.01); }
	{ phase = phase + (2pi/80); zoom = zoom * zoomf; };
	thisThread.randSeed = seed;
	Pen.use {
		var p1 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var p2 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var xscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var yscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var xlates = { 8.rand2 } ! 2;
		var ylates = { 8.rand2 } ! 2;
		var rots = { 2pi.rand + phase } ! 2;
		var xform;
		xscales = (xscales ++ (1/xscales)) * 1;
		yscales = (yscales ++ (1/yscales)) * 1;
		xlates = xlates ++ xlates.neg;
		ylates = ylates ++ xlates.neg;
		rots = rots ++ rots.neg;
		xform = {|i| [xlates[i], ylates[i], rots[i], xscales[i], yscales[i]] } ! 4;
		Pen.strokeColor = Color.rand(0, 1.0);
		Pen.width = 8.linrand + 1;
		Pen.translate(400, 400);
		Pen.scale(zoom, zoom);
		Pen.translate(-400, -400);
		1200.do {
			var p, rot, xlate, ylate, xscale, yscale;
			Pen.width = 8.linrand + 1;
			Pen.beginPath;
			#rot, xlate, ylate, xscale, yscale = xform.choose;
			Pen.translate(xlate, ylate);
			Pen.rotate(rot, h/2, v/2);
			Pen.scale(xscale, yscale);
				Pen.moveTo(p1);
				Pen.lineTo(p2);
			Pen.stroke;
		};
	}+
		Pen.use {
		var p1 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var p2 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var xscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var yscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var xlates = { 8.rand2 } ! 2;
		var ylates = { 8.rand2 } ! 2;
		var rots = { 2pi.rand + phase } ! 2;
		var xform;
		xscales = (xscales ++ (1/xscales)) * 1;
		yscales = (yscales ++ (1/yscales)) * 1;
		xlates = xlates ++ xlates.neg;
		ylates = ylates ++ xlates.neg;
		rots = rots ++ rots.neg;
		xform = {|i| [xlates[i], ylates[i], rots[i], xscales[i], yscales[i]] } ! 4;
		Pen.strokeColor = Color.rand(0, 1.0);
		Pen.width = 8.linrand + 10;
		Pen.translate(400, 400);
		Pen.scale(zoom, zoom);
		Pen.translate(-400, -400);
		1200.do {
			var p, rot, xlate, ylate, xscale, yscale;
			Pen.width = 4.linrand + 1;
			Pen.beginPath;
			#rot, xlate, ylate, xscale, yscale = xform.choose;
			Pen.translate(xlate, ylate);
			Pen.rotate(rot, h/2, v/2);
			Pen.scale(xscale, yscale);
				Pen.moveTo(p1);
				Pen.lineTo(p2);
			Pen.stroke;
		};
	}+
		Pen.use {
		var p1 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var p2 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var xscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var yscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var xlates = { 8.rand2 } ! 2;
		var ylates = { 8.rand2 } ! 2;
		var rots = { 2pi.rand + phase } ! 2;
		var xform;
		xscales = (xscales ++ (1/xscales)) * 1;
		yscales = (yscales ++ (1/yscales)) * 1;
		xlates = xlates ++ xlates.neg;
		ylates = ylates ++ xlates.neg;
		rots = rots ++ rots.neg;
		xform = {|i| [xlates[i], ylates[i], rots[i], xscales[i], yscales[i]] } ! 4;
		Pen.strokeColor = Color.rand(0, 1.0);
		Pen.width = 8.linrand + 100;
		Pen.translate(400, 400);
		Pen.scale(zoom, zoom);
		Pen.translate(-400, -400);
		1200.do {
			var p, rot, xlate, ylate, xscale, yscale;
			Pen.width = 2.linrand + 1;
			Pen.beginPath;
			#rot, xlate, ylate, xscale, yscale = xform.choose;
			Pen.translate(xlate, ylate);
			Pen.rotate(rot, h/2, v/2);
			Pen.scale(xscale, yscale);
				Pen.moveTo(p1);
				Pen.lineTo(p2);
			Pen.stroke;
		};

	}+
		Pen.use {
		var p1 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var p2 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var xscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var yscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var xlates = { 8.rand2 } ! 2;
		var ylates = { 8.rand2 } ! 2;
		var rots = { 2pi.rand + phase } ! 2;
		var xform;
		xscales = (xscales ++ (1/xscales)) * 1;
		yscales = (yscales ++ (1/yscales)) * 1;
		xlates = xlates ++ xlates.neg;
		ylates = ylates ++ xlates.neg;
		rots = rots ++ rots.neg;
		xform = {|i| [xlates[i], ylates[i], rots[i], xscales[i], yscales[i]] } ! 4;
		Pen.strokeColor = Color.rand(0, 1.0);
		Pen.width = 8.linrand + 500;
		Pen.translate(400, 400);
		Pen.scale(zoom, zoom);
		Pen.translate(-400, -400);
		1200.do {
			var p, rot, xlate, ylate, xscale, yscale;
			Pen.width = 0.8.linrand + 1;
			Pen.beginPath;
			#rot, xlate, ylate, xscale, yscale = xform.choose;
			Pen.translate(xlate, ylate);
			Pen.rotate(rot, h/2, v/2);
			Pen.scale(xscale, yscale);
				Pen.moveTo(p1);
				Pen.lineTo(p2);
			Pen.stroke;
		};
	}+
		Pen.use {
		var p1 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var p2 = Point(20.rand2 + (h/2), 20.rand2 + (v/2));
		var xscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var yscales = { exprand(2** -0.1, 2**0.1) } ! 2;
		var xlates = { 8.rand2 } ! 2;
		var ylates = { 8.rand2 } ! 2;
		var rots = { 2pi.rand + phase } ! 2;
		var xform;
		xscales = (xscales ++ (1/xscales)) * 1;
		yscales = (yscales ++ (1/yscales)) * 1;
		xlates = xlates ++ xlates.neg;
		ylates = ylates ++ xlates.neg;
		rots = rots ++ rots.neg;
		xform = {|i| [xlates[i], ylates[i], rots[i], xscales[i], yscales[i]] } ! 4;
		Pen.strokeColor = Color.rand(0, 1.0);
		Pen.width = 8.linrand + 1000;
		Pen.translate(400, 400);
		Pen.scale(zoom, zoom);
		Pen.translate(-400, -400);
		1200.do {
			var p, rot, xlate, ylate, xscale, yscale;
			Pen.width = 0.03.linrand + 1;
			Pen.beginPath;
			#rot, xlate, ylate, xscale, yscale = xform.choose;
			Pen.translate(xlate, ylate);
			Pen.rotate(rot, h/2, v/2);
			Pen.scale(xscale, yscale);
				Pen.moveTo(p1);
				Pen.lineTo(p2);
			Pen.stroke;
		};
	};

};
{ while { run } { w.refresh; 0.05.wait; } }.fork(AppClock)
+
Routine.run({
	loop({
		play({
			Pan2.ar(EnvGen.ar(e, doneAction:2) *
				PMOsc.ar(400.0.rand,80.0.rand, Line.kr(0.0, 12.0.rand,9),0,0.1068621), 1.0.rand2)});
		2.wait;
	})
})
+
Routine.run({
	loop({
		play({
			Pan2.ar(EnvGen.ar(f, doneAction:2) *
				PMOsc.ar(800.0.rand,160.0.rand, Line.kr(0.0, 12.0.rand,9),0,0.1068621), 1.0.rand2)});
		3.wait;
	})
})
+
Routine.run({
	loop({
		play({
			Pan2.ar(EnvGen.ar(g, doneAction:2) *
				PMOsc.ar(80.0.rand,40.0.rand, Line.kr(0.0,20.0.rand,22),0,0.1068621), 1.0.rand2)});
		5.wait;
	})
})

)




