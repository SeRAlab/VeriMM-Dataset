module top_module(
    X   ,
    A1  ,
    A2  ,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire AND1;
    wire AND2;
    wire OR1;
    
    assign AND1 = A1 & A2;
    assign AND2 = B1 & B2;
    assign OR1 = AND1 | AND2;
    
    assign X = (VPWR) ? 1 :
               (VGND) ? 0 :
               (VPB & VNB) ? 1 :
               (VPB & ~VNB) ? 0 :
               (~VPB & VNB) ? 1 :
               OR1;
    
endmodule