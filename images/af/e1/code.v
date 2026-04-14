module xor_gate_module(
    input a,
    input b,
    output y
);

assign y = a ^ b;

endmodule

module top_xor_gate_module(
    input a,
    input b,
    output y
);

xor_gate_module u_xor_gate_module (
    .a(a),
    .b(b),
    .y(y)
);

endmodule