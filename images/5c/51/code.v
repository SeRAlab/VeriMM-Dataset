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
);wire AB, CD, ABCD;

// OR gate for A and B
or AB_or(AB, A, B);

// OR gate for C and D
or CD_or(CD, C, D);

// OR gate for AB and CD
or ABCD_or(ABCD, AB, CD);

assign X = ABCD;

endmodule