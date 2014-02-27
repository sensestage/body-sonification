/// we can calculate the angles of inclination of the sensor, in radians:

~theta = atan2( ~x, ( pow(~y,2) + pow(~z,2) ).sqrt );
~psi = atan2( ~y, ( pow(~x,2) + pow(~z,2) ).sqrt );
~phi = atan2( ( pow(~x,2) + pow(~y,2) ).sqrt, ~z );

// or in datanodes:

x.addExpected( 501 );
(
x.nodes[301].action = { |data|
    x.setData( 501, [
        atan2( data[0], ( pow( data[1], 2) + pow( data[2], 2 ) ).sqrt ),
        atan2( data[1], ( pow( data[0], 2) + pow( data[2], 2 ) ).sqrt ),
        atan2( ( pow( data[1], 2) + pow( data[2], 2 ) ).sqrt, data[2] ),
    ]*180/pi); // angle in degrees
};
);

// note that we have now overwritten our previous action for node 301!