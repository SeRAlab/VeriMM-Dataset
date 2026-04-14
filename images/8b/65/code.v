module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    input D1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Y
);assign Y = ((A1 & A2) | (B1 & C1 & D1) | (VPWR & !VGND) | (VPB & !VNB));

endmodule