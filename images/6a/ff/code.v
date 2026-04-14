module M(
    input a,
    input b,
    output p
);
    assign p = a & b;
endmodule

module N(
    input a,
    input b,
    output p
);
    assign p = a & b;
endmodule

module top_module(
    input a,
    input b,
    output p
);
    wire m1_out, m2_out, n1_out, n2_out;
    wire nand_out, or_out;

    M m1(.a(a), .b(b), .p(m1_out));
    M m2(.a(a), .b(b), .p(m2_out));
    N n1(.a(a), .b(b), .p(n1_out));
    N n2(.a(a), .b(b), .p(n2_out));

    assign nand_out = ~(m1_out & n1_out);
    assign or_out = m2_out | n2_out;

    assign p = nand_out & or_out;
endmodule