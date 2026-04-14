module bw_u1_aoi221_4x (
    z,
    c1,
    c2,
    b1,
    b2,
    a );
    output z;
    input  c1;
    input  c2;
    input  b1;
    input  b2;
    input  a; 
    assign z = ~(( c1 & c2 ) | (b1&b2)| (a));
endmodule