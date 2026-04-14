module top_module(
    X,
    A,
    B,
    C,
    D
);// Module ports
    output X;
    input  A;
    input  B;
    input  C;
    input  D;

    // Local signals
    wire and0_out;
    wire and1_out;

    // Using AND gates from standard library
    and and0(and0_out, A, B, C); // Use built-in AND gate
    and and1(and1_out, and0_out, D); // Use built-in AND gate
    buf buf0 (X, and1_out); // Buffer to drive output

endmodule