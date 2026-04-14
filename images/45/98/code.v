module top_module(
    input  A,
    input  B,
    input  C,
    input  D,
    output Y,

    input  VPB,
    input  VPWR,
    input  VGND,
    input  VNB
);assign Y = ~(A & B & C & D);

endmodule