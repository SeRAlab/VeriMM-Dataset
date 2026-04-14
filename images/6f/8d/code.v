module top_module(
    input A,
    input B,
    input CIN,
    output SUM,
    output COUT
);// Local signals
    wire and1_out, and2_out, and3_out, and4_out, or1_out, or2_out, or3_out;

    // AND gates
    and and1 (and1_out, A, B);
    and and2 (and2_out, A, CIN);
    and and3 (and3_out, B, CIN);
    and and4 (and4_out, and1_out, CIN);

    // OR gates
    or or1 (or1_out, and1_out, and2_out);
    or or2 (or2_out, and3_out, and4_out);
    or or3 (or3_out, or1_out, or2_out);

    // Output
    assign SUM = or3_out;
    assign COUT = or1_out | and3_out | and2_out | and1_out;

endmodule