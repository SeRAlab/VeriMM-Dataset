module top_module(
    X,
    A
);output X;
    input  A;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign X = A;

endmodule