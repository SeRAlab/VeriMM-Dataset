module top_module(
    input A,
    input B,
    input CIN,
    output SUM,
    output COUT
);wire and1_out;
    wire and2_out;
    wire xor1_out;
    wire xor2_out;
    wire or1_out;

    and and1 (and1_out, A, B);
    and and2 (and2_out, and1_out, CIN);
    xor xor1 (xor1_out, A, B);
    xor xor2 (xor2_out, xor1_out, CIN);
    or or1 (or1_out, and2_out, xor2_out);

    assign SUM = xor1_out ^ CIN;
    assign COUT = or1_out;

endmodule