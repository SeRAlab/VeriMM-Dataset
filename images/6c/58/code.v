module top_module(
    X   ,
    A   ,
    B   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A   ;
    input  B   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire A_int, B_int, X_int;

    assign A_int = A & VPB;
    assign B_int = B & VNB;

    assign X_int = (A_int ^ B_int);

    assign X = X_int & VPWR & VGND;

endmodule