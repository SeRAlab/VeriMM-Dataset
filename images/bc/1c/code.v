module top_module(
    Y   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    VDD
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  VDD ;

    wire n1, n2, n3, n4, n5;
    assign n1 = ~A1;
    assign n2 = ~A2;
    assign n3 = ~A3;
    assign n4 = ~B1;
    assign n5 = n1 & n2 & n3 & n4;
    assign Y = ~n5;

endmodule