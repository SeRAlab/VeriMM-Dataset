module top_module(
    A1  ,
    A2  ,
    B1  ,
    VPWR,
    X   ,
    VGND,
    VPB ,
    VNB 
);output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    assign X = A1 & A2 & B1 & VPWR;
    
endmodule