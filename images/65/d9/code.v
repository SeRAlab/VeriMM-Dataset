module top_module(
    A1  ,
    A2  ,
    B1  ,
    B2  ,
    C1  ,
    C2  ,
    C3  ,
    X
);input  A1  ;
    input  A2  ;
    input  B1  ;
    input  B2  ;
    input  C1  ;
    input  C2  ;
    input  C3  ;
    output X   ;

    assign X = (A1 & A2 & B1 & B2) | ~(C1 | C2 | C3);

endmodule