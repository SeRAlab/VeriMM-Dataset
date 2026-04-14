module top_module(
    X,
    A1,
    A2,
    B1
);output X;
    input A1;
    input A2;
    input B1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    assign X = (A1) ? 1 : ((A2 & B1) ? 1 : 0);

endmodule