module top_module(
    Y   ,
    A   ,
    B   ,
    C   ,
    VPWR,
    VGND
);output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  VPWR;
    input  VGND;

    wire wire1;

    // Using a behavioral description for the AND operation
    assign wire1 = A & B & C;

    assign Y = wire1;

endmodule