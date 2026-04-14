module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    input C1,
    input C2,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output X
);assign X = (A1 & A2) | (B1 & B2) | (C1 & C2) | (VPWR & !VGND) | (VPB & !VNB);

endmodule