module bw_u1_nand2_1x (
    z,
    a,
    b );
    output z;
    input  a;
    input  b;
    assign z = ~( a & b );
endmodule