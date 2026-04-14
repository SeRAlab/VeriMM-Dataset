module bw_u1_ao2222_4x (
    z,
    a1,
    a2,
    b1,
    b2,
    c1,
    c2,
    d1,
    d2 );
    output z;
    input  a1;
    input  a2;
    input  b1;
    input  b2;
    input  c1;
    input  c2;
    input  d1;
    input  d2;
    assign z = ((d1&d2) | ( c1 & c2 ) | (b1&b2)| (a1& a2));
endmodule