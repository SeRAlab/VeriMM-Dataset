module xor_gate(
    input a,
    input b,
    output reg out
);

always @(*)
begin
    out = a ^ b;
end

endmodule
module top_module(
    input a,
    input b,
    output reg out_always_comb
);

xor_gate xor_gate_inst(
    .a(a),
    .b(b),
    .out(out_always_comb)
);

endmodule
