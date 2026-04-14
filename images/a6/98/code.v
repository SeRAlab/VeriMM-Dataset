module top_module(
    A,
    B,
    C,
    X
);// Module ports
    output X;
    input  A;
    input  B;
    input  C;

    // Local signals
    wire or0_out_X;

    // Implement the OR gate here
    or or0 (or0_out_X, A, B, C);

    // Implement the buffer here
    buf buf0 (X, or0_out_X);

endmodule