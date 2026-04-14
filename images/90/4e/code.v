module top_module(
    Y   ,
    A1_N,
    A2_N,
    B1  ,
    B2
);output Y   ;
    input  A1_N;
    input  A2_N;
    input  B1  ;
    input  B2  ;

    wire and1;
    wire and2;

    assign and1 = A1_N & A2_N;
    assign and2 = B1 & B2;

    assign Y = and1 | and2;

endmodule