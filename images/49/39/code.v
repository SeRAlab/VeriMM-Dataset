module top_module(
    A,
    B,
    C,
    D,
    X,
    VPWR,
    VGND
);input A;
    input B;
    input C;
    input D;
    output X;
    input VPWR;
    input VGND;

    wire ab, cd, abcd;

    // Replaced 'sky130_fd_sc_hs__xnor3' with 'xnor' for standard xnor functionality.
    assign ab = ~(A ^ B);
    assign cd = ~(C ^ D);
    assign abcd = ~(ab ^ cd);

    assign X = abcd;

endmodule