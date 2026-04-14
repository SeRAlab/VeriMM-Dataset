module top_module(
    A,
    B,
    C,
    D,
    S0,
    S1,
    Y
);input A, B, C, D, S0, S1;
    output Y;

    wire not_S0, not_S1, and1_out, and2_out, and3_out, and4_out;

    assign not_S0 = ~S0;
    assign not_S1 = ~S1;

    and and1 (and1_out, A, not_S0, not_S1);
    and and2 (and2_out, B, not_S0, S1);
    and and3 (and3_out, C, S0, not_S1);
    and and4 (and4_out, D, S0, S1);

    assign Y = and1_out | and2_out | and3_out | and4_out;

endmodule