module top_module(
    input  A,
    input  B,
    input  C,
    input  D,
    input  S0,
    input  S1,
    output Y
);wire S0_N, S1_N;

    // Invert select signals
    not(S0_N, S0);
    not(S1_N, S1);

    // Generate control signals for and gates
    wire ctrl0, ctrl1, ctrl2, ctrl3;
    and(ctrl0, A, B, S0_N, S1_N);
    and(ctrl1, A, C, S0, S1_N);
    and(ctrl2, B, D, S0_N, S1);
    and(ctrl3, C, D, S0, S1);

    // Combine control signals using or gates
    or(Y, ctrl0, ctrl1, ctrl2, ctrl3);

endmodule