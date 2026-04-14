module top_module(
    X   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    assign X = ((A1 & ~A2) | (A1 & A2 & A3) | (~A1 & ~A2 & B1));
    
endmodule