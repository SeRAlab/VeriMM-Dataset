module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    input B2,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output X
);assign X = (A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~VPWR & ~VGND & ~VPB & ~VNB);

endmodule