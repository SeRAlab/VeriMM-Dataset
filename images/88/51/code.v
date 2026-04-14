module top_module(
    X,
    A,
    B,
    C,
    D
);output X;
    input  A;
    input  B;
    input  C;
    input  D;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign X = A | B | C | D;

endmodule