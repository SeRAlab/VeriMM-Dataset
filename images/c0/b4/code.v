module bw_u1_xnor2_0p6x (
    z,
    a,
    b );
    output z;
    input  a;
    input  b;
    assign z = ~( a ^ b );
endmodule