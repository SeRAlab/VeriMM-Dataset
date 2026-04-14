module top_module(
    Y   ,
    A1_N,
    A2_N,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1_N;
    input  A2_N;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    assign Y = (A1_N & A2_N & ~B1 & ~B2) | (A1_N & ~A2_N & B1 & B2);

endmodule