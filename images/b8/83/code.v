module top_module(
    X,
    A_N,
    B,
    C,
    D
);output X;
    input A_N, B, C, D;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Internal net declarations
    wire n1, n2, n3;

    // AND gate logic
    assign n1 = A_N & B;
    assign n2 = C & D;
    assign n3 = n1 & n2;
    assign X = ~n3;

endmodule