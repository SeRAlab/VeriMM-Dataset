module top_module(
    A,
    B,
    C,
    D,
    Y
);// Module ports
    input  A;
    input  B;
    input  C;
    input  D;
    output Y;

    // Local signals
    wire and0_out;
    wire and1_out;
    wire and2_out;

    // AND gates
    and and0 (and0_out, A, B);
    and and1 (and1_out, C, D);
    and and2 (Y, and0_out, and1_out);

endmodule