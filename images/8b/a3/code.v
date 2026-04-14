module top_module(
    input  A1  ,
    input  A2  ,
    input  A3  ,
    input  B1  ,
    input  C1  ,
    output Y   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);wire sum = A1 + A2 + A3;

    assign Y = (sum * B1) - (A1 * C1);

endmodule