module top_module(
    Y   ,
    A   ,
    B   ,
    VPWR,
    VGND
);output Y   ;
    input  A   ;
    input  B   ;
    input  VPWR; // Power supply input
    input  VGND; // Ground reference input

    // Simple AND gate implementation
    assign Y = A & B;

endmodule