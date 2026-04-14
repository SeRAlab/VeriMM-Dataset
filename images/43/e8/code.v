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

    wire sel;

    assign sel = VPB & ~VNB;

    assign X = sel ? A1 : A2;

    assign X = sel ? A1 : B1;

    assign X = sel ? B2 : A2;

endmodule