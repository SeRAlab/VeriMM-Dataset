module top_module(
    output x,
    input a0,
    input a1,
    input a2,
    input a3,
    input s0,
    input s1
);wire not_s0, not_s1;
    wire and1_out, and2_out, and3_out, and4_out;
    wire or1_out, or2_out;

    // Invert select signals
    not not_s0_gate (not_s0, s0);
    not not_s1_gate (not_s1, s1);

    // AND gates for each input and select signal combination
    and and1_gate (and1_out, a0, not_s1, not_s0);
    and and2_gate (and2_out, a1, not_s1, s0);
    and and3_gate (and3_out, a2, s1, not_s0);
    and and4_gate (and4_out, a3, s1, s0);

    // OR gates for the output
    or or1_gate (or1_out, and1_out, and2_out);
    or or2_gate (or2_out, and3_out, and4_out);
    or or3_gate (x, or1_out, or2_out);

endmodule