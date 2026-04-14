module d_latch (
    input D,
    input GATE,
    input RESET,
    input VPWR,
    input VGND,
    output Q
);

    wire nGATE;
    wire nRESET;
    wire nD;

    assign nGATE = ~GATE;
    assign nRESET = ~RESET;
    assign nD = ~D;

    wire Qbar;
    wire Qbarbar;

    and and1 (Qbar, nD, nGATE, VPWR, VGND);
    and and2 (Qbarbar, D, nGATE, VPWR, VGND);

    nor nor1 (Q, Qbar, nRESET, VPWR, VGND);
    nor nor2 (Q, Qbarbar, RESET, VPWR, VGND);

endmodule