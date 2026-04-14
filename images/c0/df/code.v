module bw_u1_oai31_2x (
    z,
    b1,
    b2,
    b3,
    a );
    output z;
    input  b1;
    input  b2;
    input  b3;
    input  a;
    assign z = ~(( b1 | b2|b3 ) & ( a ));
endmodule