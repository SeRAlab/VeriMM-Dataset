module top_module(
    X,
    A_N,
    B
);output X;
    input A_N;
    input B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    assign X = ~A_N & B;

endmodule