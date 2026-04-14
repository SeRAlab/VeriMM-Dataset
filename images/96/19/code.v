module top_module(
    X,
    A1,
    A2,
    B1,
    B2
);output X;
    input  A1;
    input  A2;
    input  B1;
    input  B2;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire nA1, nA2, nB1, nB2;

    // Using basic gates to implement an XOR functionality
    assign nA1 = ~(A1 & A2);
    assign nA2 = ~(A1 | A2);
    assign nB1 = ~(B1 & B2);
    assign nB2 = ~(B1 | B2);

    assign X = (nA1 & nB1) | (A1 & A2 & nB2) | (nA2 & B1 & B2);

endmodule