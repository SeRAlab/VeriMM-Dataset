module top_module(
    input wire A_N,
    input wire B,
    input wire C,
    input wire VPWR,
    input wire VGND,
    input wire VPB,
    input wire VNB,
    output wire X
);assign X = (A_N == 1'b1) && (B == 1'b1) && (C == 1'b1) ? 1'b1 :
               (A_N == 1'b0) || (B == 1'b0) || (C == 1'b0) ? 1'b0 :
               1'bx;

endmodule