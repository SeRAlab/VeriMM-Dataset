module bw_u1_aoi211_1x (
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
    assign z = ~(( c1 & c2 ) | (a)| (b));
endmodule