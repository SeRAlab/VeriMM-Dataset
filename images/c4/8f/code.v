module full_adder (
    input A,
    input B,
    input CIN,
    output SUM,
    output COUT
);

    // local signals
    wire xor1_out, xor2_out, and1_out, and2_out, and3_out, or1_out, or2_out;

    // XOR gates
    xor xor1 (xor1_out, A, B);
    xor xor2 (xor2_out, xor1_out, CIN);

    // AND gates
    and and1 (and1_out, A, B);
    and and2 (and2_out, B, CIN);
    and and3 (and3_out, A, CIN);

    // OR gates
    or or1 (or1_out, and1_out, and2_out);
    or or2 (or2_out, or1_out, and3_out);

    // assign outputs
    assign SUM = xor2_out;
    assign COUT = or2_out;

endmodule