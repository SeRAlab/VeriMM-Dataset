module top_module(
    X   ,
    A1  ,
    A2  ,
    B1_N
);output X   ;
    input  A1  ;
    input  A2  ;
    input  B1_N;

    assign X = (~A1 & A2 & B1_N) | (A1 & ~A2 & B1_N) | (A1 & A2 & ~B1_N);

endmodule