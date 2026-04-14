module top_module(
    X   ,
    A1_N,
    A2_N,
    B1  ,
    B2
);output X;
    input  A1_N;
    input  A2_N;
    input  B1;
    input  B2;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire W1, W2, W3, W4;

    // Intermediate outputs for the AND gates
    assign W1 = A1_N & A2_N & B1 & B2;
    assign W2 = A1_N & A2_N & B1 & ~B2;
    assign W3 = A1_N & A2_N & ~B1 & B2;
    assign W4 = A1_N & A2_N & ~B1 & ~B2;

    // Final output using OR operation
    assign X = W1 | W2 | W3 | W4;

endmodule