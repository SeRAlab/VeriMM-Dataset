module xor_gate(
    input a,
    input b,
    output out_comb
);

assign out_comb = a ^ b;

endmodule

module top_module(
    input a,
    input b,
    output reg out_comb
);

xor_gate xor_inst(
    .a(a),
    .b(b),
    .out_comb(out_comb)
);

endmodule