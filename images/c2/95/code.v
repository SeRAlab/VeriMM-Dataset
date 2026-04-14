module nor_using_nand(
    input a,
    input b,
    output out
);

wire nand1_out;
wire nand2_out;

nand nand1(
    .a(a),
    .b(a),
    .out(nand1_out)
);

nand nand2(
    .a(b),
    .b(b),
    .out(nand2_out)
);

nand nand3(
    .a(nand1_out),
    .b(nand2_out),
    .out(out)
);

endmodule

module top_module(
    input a,
    input b,
    output out
);

nor_using_nand nor_gate(
    .a(a),
    .b(b),
    .out(out)
);

endmodule