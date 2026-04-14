module top_module(
    Y   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire AB, CD, ABCD;
    assign AB = ~(A & B);
    assign CD = ~(C & D);
    assign ABCD = ~(AB & CD);
    assign Y = ABCD;

endmodule