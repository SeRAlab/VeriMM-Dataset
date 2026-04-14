module top_module(
    input  A,
    input  B,
    input  sel,
    output out,
    input  VPB,
    input  VPWR,
    input  VGND,
    input  VNB
);assign out = sel ? B : A;

endmodule