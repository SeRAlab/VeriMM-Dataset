module bw_u1_inv_1p4x (
    z,
    a );
    output z;
    input  a;
    assign z = ~( a );
endmodule