module top_module(
    X   ,
    A1  ,
    A2  ,
    B1  ,
    C1  ,
    D1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  C1  ;
    input  D1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    assign X = (A1 && !A2) ? 1 :
               (!A1 && A2) ? 0 :
               (A1 && A2) ? 0 :
               (!A1 && !A2) ? 1 :
               (B1) ? 0 :
               (C1) ? 1 :
               (D1) ? 0 :
               (VPWR) ? 1 :
               (VGND) ? 0 :
               (VPB) ? 0 :
               (VNB) ? 1 :
               0;

endmodule