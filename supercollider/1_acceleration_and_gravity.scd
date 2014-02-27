//x.addExpected( 101 );
//x.nodes[1].action = { |data| x.setData( 101, data.copyRange( 4,6 ) ); };

// look at the data from the accelerometer:
x.nodes[101].data;

// [ 0.50030523538589, 0.50372362136841, 0.53131484985352 ]

// turn the accelerometer:
x.nodes[101].data;
//[ 0.49908435344696, 0.53351241350174, 0.50054937601089 ]

x.nodes[101].data;

//[ 0.50152605772018, 0.46880722045898, 0.49847394227982 ]

// --> depending on the orientation the values are around:
// 0.5 for axes not in direction of gravity
// 0.5 +/- 0.03 for axes in direction of gravity

// let's create a data node which takes this as a measure:
x.addExpected( 201 );
x.nodes[101].action = { |data| x.setData( 201, data - 0.5 / 0.03 ); };

// now we have a node where data is:
// around 0 when not touched by graviation
// at +1 when pointing in direction of gravitation
// at -1 when pointing in opposite direction
// somewhere in between when pointing halfway in one of these directions

// but fast movements will disturb the signal!

// we can slow down the data, by taking the mean of the signal:

// In SuperCollider we can do this, while making use of some functions on the server, so let's start it first:

s.boot;

// make a simple dictionary to keep data:
q = q ? ();

x.nodes[201].createBus(s); // create a bus on the server for the data
q.meanNode = MeanNode.new( 301, x, x.nodes[201].bus, s );
// the mean has a couple of settings:
q.meanNode.settings;

// we want to change the setting for the length, this is the number of samples or time window over which the mean is taken.
// the default is 50, which is 67ms
50 * s.options.blockSize / s.sampleRate;

// 200 is a nice window
200 * s.options.blockSize / s.sampleRate;

q.meanNode.set( \length, 200 );

// start the mean node:
q.meanNode.start;

// the signal is less sensitive to disturbances now!


// let's also listen to the signal:

Ndef( \simpleSines, { SinOsc.ar( \freq.kr( 500 ) * \fmmod.kr( [ 1, 1.5, 2 ] ), 0, 0.1 ).sum } );

Ndef( \simpleSines ).play;

NdefMixer.new(s);

// data is between -1 and 1, we scale it by half, and add [1,1.5,2]
x.nodes[301].action = { |data| Ndef( \simpleSines ).setn( \fmmod, data/2 + [1,1.5,2] ) };

Ndef( \simpleSines ).stop;


// change is more interesting than continuous sound, so let's add something more

// another statistical measure is standard deviation, an indication how much a signal is changing from the mean

q.stdNode = StdDevNode.new( 401, x, x.nodes[201].bus, s );
// the standard deviation also has a couple of settings:
q.stdNode.settings;

q.stdNode.set( \length, 200 );

// start the standard deviation node:
q.stdNode.start;

// when in rest, the signal stays under 0.01
// when moved, the signal goes up to 0.5

// let's add amplitude to our sound:
Ndef( \simpleSines, { SinOsc.ar( \freq.kr( 500 ) * \fmmod.kr( [ 1, 1.5, 2 ] ), 0, 0.1 * \amp.kr( [1,1,1] ) ).sum } );

Ndef( \simpleSines ).play;

// data is between 0.01 and 0.5, we multiply by 2
x.nodes[401].action = { |data| Ndef( \simpleSines ).setn( \amp, data*2 ) };

// make it a little bit smoother, by adding a lag:

Ndef( \simpleSines, { SinOsc.ar( \freq.kr( 500 ) * \fmmod.kr( [ 1, 1.5, 2 ] ).lag( \lag.kr(0.1) ), 0, 0.1 * \amp.kr( [1,1,1] ).lag( \lag.kr(0.1) ) ).sum } );


Ndef( \simpleSines ).stop;

