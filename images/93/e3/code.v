module top_module(
    input A,
    input B,
    input Sel,
    output Out,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);assign Out = (!Sel & A) | (Sel & B);

endmodule