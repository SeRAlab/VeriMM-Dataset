module two_input_logic (
    A,
    B,
    X
);

    // Module ports
    input  A;
    input  B;
    output X;

    // Local signals
    wire not_A;
    wire not_B;
    wire and1_out;
    wire and2_out;
    wire or_out;

    //  Name        Output      Other arguments
    not not_A_gate (not_A, A);
    not not_B_gate (not_B, B);
    and and1_gate   (and1_out, A, not_B);
    and and2_gate   (and2_out, not_A, B);
    or  or_gate     (or_out, and1_out, and2_out);
    not not_out     (X, or_out);

endmodule