module top_module(
    Y   ,
    A1  ,
    A2  ,
    A3  ,
    B1  
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;

    wire temp;

    assign temp = (A1 & A2 & A3) | (~A1 & ~A2 & ~A3);

    assign Y = temp ? 1'b1 : B1;

endmodule