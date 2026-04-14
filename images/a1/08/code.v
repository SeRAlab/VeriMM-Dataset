module top_module(
    input A_N,
    input B_N,
    input C,
    input D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output X
);wire nA = ~A_N;
    wire nB = ~B_N;
    wire nC = ~C;
    wire nD = ~D;

    assign X = nA & nB & nC & nD & VPWR & VGND & VPB & VNB;

endmodule