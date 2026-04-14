module top_module(
    Y   ,
    A1  ,
    A2  ,
    B1_N,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1_N;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    assign Y = ((A1 & A2) | (VPB & !VNB)) & (!B1_N) & (VPWR) & (!VGND);

endmodule