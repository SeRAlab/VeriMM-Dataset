module bw_u1_aoi311_4x (
    z,
    c1,
    c2,
    c3,
    b, 
    a );
    output z;
    input  c1;
    input  c2;
    input  c3;
    input  b;
    input  a;
    assign z = ~(( c1 & c2& c3 ) | (a)| (b));
endmodule