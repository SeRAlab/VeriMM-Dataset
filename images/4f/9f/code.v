module top_module(
    input A,
    input B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Y
    );wire nA, nB, nAB;
    assign nA = ~A;
    assign nB = ~B;
    assign nAB = nA & nB;
    assign Y = ~nAB;

endmodule