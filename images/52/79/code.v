module top_module(
    Y  ,
    A  ,
    B  ,
    C  ,
    D_N
);output Y  ;
    input  A  ;
    input  B  ;
    input  C  ;
    input  D_N;

    wire AB, CD, ABCD;
    
    assign AB = ~(A | B);
    assign CD = ~(C | D_N);
    assign ABCD = ~(AB | CD);
    
    assign Y = ABCD;

endmodule