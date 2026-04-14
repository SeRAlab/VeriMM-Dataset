module xnor_gate_module(
    input a,
    input b,
    output y
);

assign y = ~(a ^ b);

endmodule

module top_xnor_gate_module(
    input a,
    input b,
    output y
);

xnor_gate_module u_xnor_gate_module (
    .a(a),
    .b(b),
    .y(y)
);

endmodule