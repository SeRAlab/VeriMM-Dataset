module mux4to1 (
    A   ,
    B   ,
    C   ,
    D   ,
    S0  ,
    S1  ,
    Y   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  S0  ;
    input  S1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    assign Y = (S1 & S0) ? D :
               (S1 & ~S0) ? C :
               (~S1 & S0) ? B :
               A;

endmodule