module top_module(
    input  A_N ,
    input  B   ,
    output X   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);assign X = ~A_N & B;
endmodule