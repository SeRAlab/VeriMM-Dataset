module bw_u1_aoi22_8x (
    z,
    b1,
    b2,
    a1,
    a2 );
    output z;
    input  b1;
    input  b2;
    input  a1;
    input  a2;
    assign z = ~(( a1 & a2 ) | ( b1 & b2 ));
endmodule