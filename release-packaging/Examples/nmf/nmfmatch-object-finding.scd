// using NMF, splitting a small portion, then associating components to targets, then thresholding on these target's activations to find objects.

//set some buffers
(
b = Buffer.read(s,File.realpath(FluidNMFMatch.class.filenameSymbol).dirname.withTrailingSlash ++ "../AudioFiles/Tremblay-BaB-SoundscapeGolcarWithDog.wav");
c = Buffer.new(s);
x = Buffer.new(s);
e = Buffer.new(s);
)

// train where all objects are present
(
Routine {
    FluidBufNMF.process(s,b,130000,150000,0,1, c, x, components:10);
    c.query;
}.play;
)

// wait for the query to print
// then find a component for each item you want to find. You could also sum them. Try to find a component with a good object-to-rest ratio
(
    ~dog =1;
    {PlayBuf.ar(10,c)[~dog]}.play
)

(
    ~bird = 3;
    {PlayBuf.ar(10,c)[~bird]}.play
)


// copy at least one other component to a third filter, a sort of left-over channel
(
Routine{
	FluidBufCompose.process(s, x, startChan:~dog, numChans: 1, destination: e);
	FluidBufCompose.process(s, x, startChan:~bird, numChans: 1, destStartChan: 1, destination: e, destGain:1);
	(0..9).removeAll([~dog,~bird]).do({|chan|FluidBufCompose.process(s,x, startChan:chan, numChans: 1, destStartChan: 2, destination: e, destGain:1)});
    e.query;
}.play;
)
e.plot;

//using this trained basis we can then see the activation... (wait for 5 seconds before it prints!)
(
{
	var source, blips;
	//read the source
	source = PlayBuf.ar(2, b);
	blips = FluidNMFMatch.kr(source.sum,e,3);
	}.plot(5);
)

// ...and use some threshold to 'find' objects...
(
{
	var source, blips;
	//read the source
	source = PlayBuf.ar(2, b);
	blips = Schmidt.kr(FluidNMFMatch.kr(source.sum,e,3),0.5,[10,1,1000]);
	}.plot(5);
)

// ...and use these to sonify them
(
{
	var source, blips, dogs, birds;
	//read the source
	source = PlayBuf.ar(2, b);
	blips = Schmidt.kr(FluidNMFMatch.kr(source.sum,e,3),0.5,[10,1,1000]);
	dogs = SinOsc.ar(100,0,Lag.kr(blips[0],0.05,0.15));
	birds = SinOsc.ar(1000,0,Lag.kr(blips[1],0.05,0.05));
	[dogs, birds] + source;
	}.play;
)