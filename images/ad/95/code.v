module top_module(
    input wire A1,
    input wire A2,
    input wire A3,
    input wire B1,
    input wire C1,
    input wire VPWR,
    input wire VGND,
    input wire VPB,
    input wire VNB,
    output wire Y
);assign Y = (~A1 & ~A2 & ~A3 & ~B1 & ~C1) |
               (~A1 & ~A2 & ~A3 & ~B1 &  C1) |
               (~A1 & ~A2 & ~A3 &  B1 & ~C1) |
               (~A1 & ~A2 & ~A3 &  B1 &  C1) |
               (~A1 & ~A2 &  A3 & ~B1 & ~C1) |
               (~A1 & ~A2 &  A3 & ~B1 &  C1) |
               (~A1 & ~A2 &  A3 &  B1 & ~C1) |
               (~A1 & ~A2 &  A3 &  B1 &  C1) |
               (~A1 &  A2 & ~A3 & ~B1 & ~C1) |
               (~A1 &  A2 & ~A3 & ~B1 &  C1) |
               (~A1 &  A2 & ~A3 &  B1 & ~C1) |
               (~A1 &  A2 & ~A3 &  B1 &  C1) |
               (~A1 &  A2 &  A3 & ~B1 & ~C1) |
               (~A1 &  A2 &  A3 & ~B1 &  C1) |
               (~A1 &  A2 &  A3 &  B1 & ~C1) |
               (~A1 &  A2 &  A3 &  B1 &  C1) |
               ( A1 & ~A2 & ~A3 & ~B1 & ~C1) |
               ( A1 & ~A2 & ~A3 & ~B1 &  C1) |
               ( A1 & ~A2 & ~A3 &  B1 & ~C1) |
               ( A1 & ~A2 & ~A3 &  B1 &  C1) |
               ( A1 & ~A2 &  A3 & ~B1 & ~C1) |
               ( A1 & ~A2 &  A3 & ~B1 &  C1) |
               ( A1 & ~A2 &  A3 &  B1 & ~C1) |
               ( A1 & ~A2 &  A3 &  B1 &  C1) |
               ( A1 &  A2 & ~A3 & ~B1 & ~C1) |
               ( A1 &  A2 & ~A3 & ~B1 &  C1) |
               ( A1 &  A2 & ~A3 &  B1 & ~C1) |
               ( A1 &  A2 & ~A3 &  B1 &  C1) |
               ( A1 &  A2 &  A3 & ~B1 & ~C1) |
               ( A1 &  A2 &  A3 & ~B1 &  C1) |
               ( A1 &  A2 &  A3 &  B1 & ~C1) |
               ( A1 &  A2 &  A3 &  B1 &  C1);

endmodule