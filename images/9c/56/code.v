module top_module(
    X   ,
    A1_N,
    A2_N,
    B1  ,
    B2
);output X   ;
    input  A1_N;
    input  A2_N;
    input  B1  ;
    input  B2  ;

    assign X = (A1_N & A2_N) ? 1'b0 :
               (A1_N & ~A2_N & B1 & ~B2) ? 1'b1 :
               (A2_N & ~A1_N & ~B1 & B2) ? 1'b1 :
               (A1_N & ~A2_N & (~B1 | B2)) ? 1'b0 :
               1'b0;

endmodule