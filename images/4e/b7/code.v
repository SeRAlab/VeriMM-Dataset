module top_module(
    X,
    A1,
    A2,
    B1,
    B2,
    C1
);output X;
    input A1, A2, B1, B2, C1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    assign X = (A1) ? 1 : ((A2) ? 0 : ((B1 & B2) ? 1 : (!C1)));

endmodule