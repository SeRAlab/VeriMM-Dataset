module top_module(
    input wire A,
    input wire B,
    input wire VPWR,
    input wire VGND,
    input wire VPB,
    input wire VNB,
    output wire X
);assign X = (VPWR | (VPB & !VPWR) | (VNB & !VPB & !VPWR) | (VGND & !VNB & !VPB & !VPWR));

endmodule