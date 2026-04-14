module sky130_fd_sc_hs__or3 (
    X,
    A,
    B,
    C
);

    output X;
    input  A;
    input  B;
    input  C;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign X = A | B | C;

endmodule