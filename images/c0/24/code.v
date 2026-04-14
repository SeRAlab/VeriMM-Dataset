module bw_u1_aoi222_1x (
    z,
    a1,
    a2,
    b1,
    b2,
    c1,
    c2 );
    output z;
    input  a1;
    input  a2;
    input  b1;
    input  b2;
    input  c1;
    input  c2;
    assign z = ~(( c1 & c2 ) | (b1&b2)| (a1& a2));
endmodule