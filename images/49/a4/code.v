module G(
    input a,
    input b,
    output q
);
    assign q = a | b;
endmodule

module H(
    input a,
    input b,
    output q
);
    assign q = a | b;
endmodule

module top_module(
    input a,
    input b,
    output q
);
    wire g1_out, g2_out, h1_out, h2_out;
    wire xor_out, nand_out;

    G g1(.a(a), .b(b), .q(g1_out));
    G g2(.a(a), .b(b), .q(g2_out));
    H h1(.a(a), .b(b), .q(h1_out));
    H h2(.a(a), .b(b), .q(h2_out));

    assign xor_out = g1_out ^ h1_out;
    assign nand_out = ~(g2_out & h2_out);

    assign q = xor_out & nand_out;
endmodule