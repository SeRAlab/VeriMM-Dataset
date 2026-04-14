module bw_u1_oai22_2x (
    z,
    a1,
    a2,
    b1,
    b2 );
    output z;
    input  a1;
    input  a2;
    input  b1;
    input  b2;
    assign z = ~(( a1 | a2 ) & ( b1 | b2 ));
endmodule