module mux_2to1 (
    Y   ,
    A   ,
    B   ,
    S   
);

    output Y   ;
    input  A   ;
    input  B   ;
    input  S   ;

    assign Y = (S == 1) ? B : A;

endmodule