module bw_u1_nor2_3x (
    z,
    a,
    b );
    output z;
    input  a;
    input  b;
    assign z = ~( a | b );
endmodule