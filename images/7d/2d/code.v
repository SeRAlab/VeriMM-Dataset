module nand_gate_module(
    input a,
    input b,
    output y
);

assign y = ~(a & b);

endmodule

module top_nand_gate_module(
    input a,
    input b,
    output y
);

nand_gate_module u_nand_gate_module (
    .a(a),
    .b(b),
    .y(y)
);

endmodule