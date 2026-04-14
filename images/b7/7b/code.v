module top_module(
    Y   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND,
    VPB ,
    VNB ,
    EN
);output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    input  EN  ;

    wire Y1, Y2, Y3;

    // Behavioral implementation of a 2-input XNOR gate
    assign Y1 = ~(A ^ B); // XNOR for A and B
    assign Y2 = ~(C ^ D); // XNOR for C and D
    assign Y3 = ~(Y1 ^ Y2); // XNOR for Y1 and Y2

    assign Y = EN ? Y3 : 1'b0;

endmodule