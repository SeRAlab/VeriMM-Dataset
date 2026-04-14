module not_gate_module(
    input a,
    output y
);

assign y = ~a;

endmodule

module top_not_gate_module(
    input a,
    output y
);

not_gate_module u_not_gate_module (
    .a(a),
    .y(y)
);

endmodule