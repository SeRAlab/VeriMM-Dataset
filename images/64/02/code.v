module top_module(
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    output Y
);wire notS0, notS1;
    wire and1_out, and2_out, and3_out, and4_out; // Renamed AND gate outputs
    wire or_out; // Renamed OR gate output

    // Invert the select lines
    not U1 (notS0, S0);
    not U2 (notS1, S1);

    // Create the AND gates
    and U3 (and1_out, A, notS0, notS1);
    and U4 (and2_out, B, notS0, S1);
    and U5 (and3_out, C, S0, notS1);
    and U6 (and4_out, D, S0, S1);

    // Create the OR gate
    or U7 (Y, and1_out, and2_out, and3_out, and4_out);

endmodule