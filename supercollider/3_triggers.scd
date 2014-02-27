// from our continuous signals, we can also create triggers, when going beyond a certain threshold, something happens.

(
// simplest trigger: when data is beyond it, something happens:
x.nodes[301].action = { |data|
    if ( data[0] > 0.5 ){ "take action!".postln; };
};
);

// keep track of state:

k = ();
k.wasTriggered = false;

(
// simplest trigger: when data is beyond it, something happens:
x.nodes[301].action = { |data|
    if ( data[0] > 0.5 ){
        if ( k.wasTriggered.not ){
            k.wasTriggered = true;
            "take action!".postln;
        }
    }{ // below threshold:
        // could take another action for going "off":
        if ( k.wasTriggered ){
            "take off action!".postln;
        };
        k.wasTriggered = false;
    }
};
);

// slightly more complex trigger: threshold for on is higher than threshold for off, this can prevent false retriggers:
k.thresholdOn = 0.5;
k.thresholdOff = 0.25;
(
// simplest trigger: when data is beyond it, something happens:
x.nodes[301].action = { |data|
    if ( data[0] > k.thresholdOn ){
        if ( k.wasTriggered.not ){
            k.wasTriggered = true;
            "take action!".postln;
        }
    };
    if ( data[0] < k.thresholdOff ){ // below threshold:
        // could take another action for going "off":
        if ( k.wasTriggered ){
            "take off action!".postln;
        };
        k.wasTriggered = false;
    }
};
);

// with these triggers you can also take the absolute value of the data, so the trigger works in either direction:
(
// simplest trigger: when data is beyond it, something happens:
x.nodes[301].action = { |data|
    if ( data[0].abs > k.thresholdOn ){
        if ( k.wasTriggered.not ){
            k.wasTriggered = true;
            "take action!".postln;
        }
    };
    if ( data[0].abs < k.thresholdOff ){ // below threshold:
        // could take another action for going "off":
        if ( k.wasTriggered ){
            "take off action!".postln;
        };
        k.wasTriggered = false;
    }
};
);

// or you can take different actions based on the direction:

k.wasTriggeredPos = false;
k.wasTriggeredNeg = false;

(
x.nodes[301].action = { |data|
    if ( data[0] > k.thresholdOn ){
        if ( k.wasTriggeredPos.not ){
            k.wasTriggeredPos = true;
            k.wasTriggeredNeg = false;
            "take action positive!".postln;
        }
    };
    if ( data[0] < k.thresholdOff ){ // below threshold:
        // could take another action for going "off":
        if ( k.wasTriggeredPos ){
            "take off action positive!".postln;
        };
        k.wasTriggeredPos = false;
    };
    if ( data[0] < (-1*k.thresholdOn) ){
        if ( k.wasTriggeredNeg.not ){
            k.wasTriggeredPos = false;
            k.wasTriggeredNeg = true;
            "take action negative!".postln;
        }
    };
    if ( data[0] > (-1*k.thresholdOff) ){ // below threshold:
        // could take another action for going "off":
        if ( k.wasTriggeredNeg ){
            "take off action negative!".postln;
        };
        k.wasTriggeredNeg = false;
    };
};
);

// these examples use the tilt, but you could also use the standard deviation as a measure for when to trigger things.
