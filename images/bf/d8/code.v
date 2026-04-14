module bw_u1_inv_8x (
    z,
    a );
    output z;
    input  a;
    assign z = ~( a );
endmodule