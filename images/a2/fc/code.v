module top_module(
    input  a,
    input  b,
    input  sel,
    output out
);wire not_sel;
    wire and_a;
    wire and_b;
    wire or_ab;

    not not_gate (not_sel, sel);
    and and_gate_a (and_a, a, not_sel);
    and and_gate_b (and_b, b, sel);
    or or_gate (or_ab, and_a, and_b);
    not not_gate_out (out, or_ab);

endmodule