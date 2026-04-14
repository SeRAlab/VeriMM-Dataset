module top_module(
    input  wire A1,
    input  wire A2,
    input  wire B1,
    input  wire C1,
    input  wire D1,
    input  wire VPWR,
    input  wire VGND,
    input  wire VPB,
    input  wire VNB,
    output wire Y
);assign Y = (A1 % 2 == 1) ||
               ((A1 % 2 == 0) && (A2 % 2 == 1)) ||
               ((A1 % 2 == 0) && (A2 % 2 == 0) && (B1 % 2 == 1) && (C1 % 2 == 1) && (D1 % 2 == 1)) ||
               (VPWR > VGND) ||
               (VPB == VNB);

endmodule