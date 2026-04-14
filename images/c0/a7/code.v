module bw_u1_aoi32_2x (
    z,
    b1, 
    b2,
    b3,
    a1,
    a2 );
    output z;
    input  b1; 
    input  b2; 
    input  b3; 
    input  a1;
    input  a2;
    assign z = ~(( b1 & b2&b3 ) | ( a1 & a2 ));
endmodule