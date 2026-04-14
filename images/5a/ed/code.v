module top_module(
    A1,
    A2,
    A3,
    A4,
    B1,
    X
);// Module ports
    input  A1;
    input  A2;
    input  A3;
    input  A4;
    input  B1;
    output X;

    // Local signals
    wire and0_out; // Change to a single bit for the AND output
    wire or0_out_X;

    //  Name  Output     Other arguments
    and and0 (and0_out, A1, A2, A3, A4);
    or  or0  (or0_out_X, and0_out, B1);
    buf buf0 (X, or0_out_X);

endmodule