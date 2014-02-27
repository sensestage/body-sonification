// our standard deviation measurement gives us an idea of how much activity there has been over a certain time window:

// q.stdNode = StdDevNode.new( 401, x, x.nodes[201].bus, s );
//-- start the standard deviation node:
// q.stdNode.start;

// the standard deviation also has a couple of settings:
q.stdNode.settings;

// changing the length, will change the timewindow

q.stdNode.set( \length, 50 );

q.stdNode.set( \length, 100 );

q.stdNode.set( \length, 200 );

q.stdNode.set( \length, 1000 );

// a very long window, gives us a slower reaction on the data, we can also pump it up a little

// we can also make a comparison between two different deviations:

q.stdNode2 = StdDevNode.new( 601, x, x.nodes[201].bus, s );
//-- start the standard deviation node:
q.stdNode2.start;
// has the default window of 50
q.stdNode2.set( \length, 200 );


// divide the two:
x.addExpected( 701 );
x.nodes[601].action = { |data| x.setData( 701, x.nodes[601].data / x.nodes[401].data ); };

// sudden changes to a high activity, create a spike
// changes to lower activity, move this measure towards 0
// steady activity keep it fluctuation around 1

// measure of this on all axes together:

x.addExpected( 801 );
x.nodes[601].action = { |data|
    x.setData( 701, x.nodes[601].data / x.nodes[401].data );
    x.setData( 801, [ x.nodes[601].data.sum / x.nodes[401].data.sum ] );
};

// we can use this an automatic way to adapt the sensitivity of an instrument, if moving down to a lower activity, the instrument can be more sensitive, if moving to a higher activity, the instrument can be less sensitive.

// to go back to the mapping we had:

Ndef( \simpleSines, { SinOsc.ar( \freq.kr( 500 ) * \fmmod.kr( [ 1, 1.5, 2 ] ).lag( \lag.kr(0.1) ), 0, 0.1 * \amp.kr( [1,1,1] ).lag( \lag.kr(0.1) ) ).sum } );

(
Ndef( \simpleSines, { SinOsc.ar(
    \freq.kr( 500 ) *
    (
        \datain.kr( [0.1,0.1,0.1] ).lag( \lag.kr(0.1) )
        * \fmmul.kr(1).lag( \lag2.kr(2), \lag3.kr(1) )
        + \fmadd.kr( [  1, 1.5,  2] )
    ),
    0, 0.1 *
    \amp.kr( [1,1,1] ).lag( \lag.kr(0.1) ) * \mul.kr(1).lag( \lag2.kr(2), \lag3.kr(1) )
).sum } );
);

// data is between -1 and 1, we scale it by half, and add [1,1.5,2]
x.nodes[301].action = { |data| Ndef( \simpleSines ).setn( \datain, data ) };

x.nodes[401].action = { |data| Ndef( \simpleSines ).setn( \amp, data*2 ) };

// now we change the sensitivity based on the change in activity

(
f = ();
f.thresholdHigh = 2.1;
f.thresholdLow = 0.025;
f.lowSensitive = false;
f.highSensitive = false;

x.nodes[801].action = { |data|
    if ( data[0] > f.thresholdHigh ){
        if ( f.lowSensitive.not ){
            f.lowSensitive = true;
            f.highSensitive = false;
            Ndef( \simpleSines ).set( \mul, 0.5 );
            Ndef( \simpleSines ).set( \fmmul, 0.5 );
            "switch to low sensitivity!".postln;
        }
    };
    if ( data[0] < f.thresholdLow ){
        if ( f.highSensitive.not ){
            f.lowSensitive = false;
            f.highSensitive = true;
            Ndef( \simpleSines ).set( \mul, 2 );
            Ndef( \simpleSines ).set( \fmmul, 2 );
            "switch to high sensitivity!".postln;
        }
    };
};
);