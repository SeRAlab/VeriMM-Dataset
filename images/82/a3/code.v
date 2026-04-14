module top_module(
    input A,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Y
);assign Y = (A == 1'b0) ? 1'b1 :
               (A == 1'b1) ? 1'b0 :
               (VPWR == 1'b0 && VGND == 1'b0 && VPB == 1'b0 && VNB == 1'b0) ? 1'b1 :
               (VPWR == 1'b1 && VGND == 1'b1 && VPB == 1'b1 && VNB == 1'b1) ? 1'b0 :
               1'bx;

endmodule