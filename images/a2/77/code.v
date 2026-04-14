module top_module(
    input  A1  ,
    input  A2  ,
    input  B1  ,
    output X   ,
    
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);assign X = (A1 || (A2 && !A1) || (B1 && !A1 && !A2)) ? 1'b1 : 1'b0;

endmodule