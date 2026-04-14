module top_module(
    X   ,
    A1_N,
    A2_N,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A1_N;
    input  A2_N;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire A = ~(A1_N | A2_N);
    wire B = ~(B1 | B2);
    
    assign X = (A & B) | (A & ~B) | (~A & B);

endmodule