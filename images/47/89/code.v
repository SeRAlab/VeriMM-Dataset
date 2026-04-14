module top_module(
    input A, B, C, D,
    input S0, S1,
    output Y
);wire not_S0, not_S1, and1_out, and2_out, and3_out, and4_out;

    // Invert select signals
    not not_S0_inst (not_S0, S0);
    not not_S1_inst (not_S1, S1);

    // AND gates
    and and1_inst (and1_out, A, not_S1, not_S0);
    and and2_inst (and2_out, B, not_S1, S0);
    and and3_inst (and3_out, C, S1, not_S0);
    and and4_inst (and4_out, D, S1, S0);

    // OR gate
    assign Y = and1_out | and2_out | and3_out | and4_out;

endmodule