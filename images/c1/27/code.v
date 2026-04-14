module bw_u1_oai21_0p4x (
    z,
    b1,
    b2,
    a );
    output z;
    input  b1;
    input  b2;
    input  a;
    assign z = ~(( b1 | b2 ) & ( a ));
endmodule