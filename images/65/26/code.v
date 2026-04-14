module top_module(
    Y   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND
);output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;
    
    wire n1, n2;

    // Behavioral definition of a 4-input NOR gate
    assign n1 = ~(A | B);
    assign n2 = ~(C | D);
    assign Y  = ~(n1 | n2);

endmodule