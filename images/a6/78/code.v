module top_module(
    input a,
    input b,
    output wire out
);wire not_a, not_b;
not not_gate_a(a, not_a);
not not_gate_b(b, not_b);

wire mux_out;
assign mux_out = not_a & not_b;

not not_gate_out(mux_out, out);

endmodule