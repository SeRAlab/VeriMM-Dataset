module top_module(
    Y   ,
    A   ,
    B   ,
    C   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire AB, AC, BC;
    
    assign AB = A & B;
    assign AC = A & C;
    assign BC = B & C;
    
    assign Y = ((AB & C) | (AC & ~B) | (BC & ~A) | (~AB & ~AC & ~BC)) ? VPWR : VGND;

endmodule