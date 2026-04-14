module top_module(
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    B2  ,
    C1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  B2  ;
    input  C1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire temp;
    
    assign temp = (A1 & ~A2 & ~C1) | (~A1 & A2 & B1) | (~A1 & A2 & B2) | (A1 & A2 & (B1 | B2));
    
    assign Y = temp & VPWR & ~VGND & VPB & ~VNB;

endmodule