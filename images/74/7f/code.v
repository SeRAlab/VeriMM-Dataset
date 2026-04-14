module top_module(
    Y   ,
    A   ,
    B   ,
    SEL ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A   ;
    input  B   ;
    input  SEL ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    assign Y = SEL ? B : A;

endmodule