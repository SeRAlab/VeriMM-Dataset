module top_module(
    input A1,
    input A2,
    input B1,
    input VPWR,
    output X
);// Local signals
    wire or_out;
    wire and_out_X;

    // OR gate for A1 and A2
    or or_gate (or_out, A2, A1);

    // AND gate for or_out and B1
    and and_gate_X (and_out_X, or_out, B1);

    // Buffer for and_out_X and VPWR
    buf buf_gate (X, and_out_X & VPWR);

endmodule