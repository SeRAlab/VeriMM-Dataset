module top_module(
    input  A,
    input  B,
    input  C,
    input  D,
    input  [1:0] S,
    output Y
);wire not_S0, not_S1;
    wire and1, and2, and3, and4;
    wire or1, or2;

    // Invert select signals
    not (S[0], not_S0);
    not (S[1], not_S1);

    // AND gates
    and (A, not_S1, not_S0, and1);
    and (B, not_S1, S[0], and2);
    and (C, S[1], not_S0, and3);
    and (D, S[1], S[0], and4);

    // OR gates
    or (and1, and2, or1);
    or (and3, and4, or2);

    // Final output
    or (or1, or2, Y);

endmodule