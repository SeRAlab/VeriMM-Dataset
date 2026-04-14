module nor_gate_module(
    input a,
    input b,
    output y
);

assign y = ~(a | b);

endmodule

module top_nor_gate_module(
    input a,
    input b,
    output y
);

nor_gate_module u_nor_gate_module (
    .a(a),
    .b(b),
    .y(y)
);

endmodule