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

    wire n1, n2, n3;

    // Use a standard NOR gate with 4 inputs instead, as the unknown module is problematic
    assign n1 = ~(A | B); // First NOR operation
    assign n2 = ~(C | D); // Second NOR operation
    assign n3 = ~(n1 | n2); // Third NOR operation
    assign Y = ~(n3 | VGND); // Final NOR operation with the output

endmodule