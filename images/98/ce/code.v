module top_module(
    input  A1  ,
    input  A2  ,
    input  A3  ,
    input  A4  ,
    input  B1  ,
    output Y   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);wire and_result;

assign and_result = A1 & A2 & A3 & A4;

assign Y = B1 ? 1 : and_result;

endmodule