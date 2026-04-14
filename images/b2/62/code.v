module top_module(
    input A,
    input B,
    input C,
    input D,
    output X,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);wire AB;
    wire CD;
    wire ABCD;

    and gate1 (AB, A, B);
    and gate2 (CD, C, D);
    and gate3 (ABCD, AB, CD);
    not gate4 (X, ABCD);

endmodule