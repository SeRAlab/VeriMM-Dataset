module top_module(
    A,
    B,
    X
);input A;
    input B;
    output X;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // Buffer implementation
    assign X = A | B;

endmodule