module bw_u1_oai222_1x (
    z,
    c1,
    c2,
    b1,
    b2,
    a1,
    a2 );
    output z;
    input  c1;
    input  c2;
    input  b1;
    input  b2;
    input  a1;
    input  a2;
    assign z = ~(( c1 | c2 ) & ( a1|a2 ) & (b1|b2));
endmodule