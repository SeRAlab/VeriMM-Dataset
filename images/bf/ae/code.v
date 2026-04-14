module bw_u1_oai211_4x (
    z,
    c1,
    c2,
    b,
    a );
    output z;
    input  c1;
    input  c2;
    input  b;
    input  a;
    assign z = ~(( c1 | c2 ) & ( a ) & (b));
endmodule