module bw_u1_nor3_1p4x (
    z,
    a,
    b,
    c );
    output z;
    input  a;
    input  b;
    input  c;
    assign z = ~( a | b | c );
endmodule