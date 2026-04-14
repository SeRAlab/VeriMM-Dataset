module and_gate_module(
    input a,
    input b,
    output y
);

assign y = a & b;

endmodule

module top_and_gate_module(
    input a,
    input b,
    output y
);

and_gate_module u_and_gate_module (
    .a(a),
    .b(b),
    .y(y)
);

endmodule