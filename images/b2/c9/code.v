module top_module(
    A,
    B,
    C,
    D,
    X,
    valid_out
);output X, valid_out;
    input A, B, C, D;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    wire and2_1_out, and2_2_out;

    // Implement AND gates using built-in gates
    assign and2_1_out = A & B;
    assign and2_2_out = C & D;

    // Final AND gate to produce output X
    assign X = and2_1_out & and2_2_out;

    // Valid output indicating that all inputs are high
    assign valid_out = (A & B & C & D);

endmodule