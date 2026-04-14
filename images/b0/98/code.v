module top_module(
    input wire A1,
    input wire A2,
    input wire B1,
    input wire B2,
    input wire VPWR,
    input wire VGND,
    input wire VPB,
    input wire VNB,
    output wire X
);assign X = (A1 & A2) | (B1 & B2 & VPWR & VGND & VPB & VNB);

endmodule