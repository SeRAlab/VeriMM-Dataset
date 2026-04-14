module top_module(
    input  A1  ,
    input  A2  ,
    input  A3  ,
    input  B1  ,
    input  B2  ,
    output X   ,

    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);wire A_high = A1 & A2 & A3;
    wire B_low = ~B1 & ~B2;
    wire B_high = B1 & B2;

    assign X = (A_high & B_low) | (~A_high & B_high);

endmodule