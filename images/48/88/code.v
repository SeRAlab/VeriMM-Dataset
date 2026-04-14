module I(
    input a,
    input b,
    output z
);
    assign z = ~(a & ~b);
endmodule

module J(
    input a,
    input b,
    output z
);
    assign z = ~(a & ~b);
endmodule

module top_module(
    input a,
    input b,
    output z
);
    wire i1_out, i2_out, j1_out, j2_out;
    wire xor_out, nand_out;

    I i1(.a(a), .b(b), .z(i1_out));
    I i2(.a(a), .b(b), .z(i2_out));
    J j1(.a(a), .b(b), .z(j1_out));
    J j2(.a(a), .b(b), .z(j2_out));

    assign xor_out = i1_out ^ j1_out;
    assign nand_out = ~(i2_out & j2_out);

    assign z = xor_out & nand_out;
endmodule