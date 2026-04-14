module top_module(
    Y   ,
    A   ,
    B   ,
    VPWR,
    VGND
);output Y   ;
    input  A   ;
    input  B   ;
    input  VPWR;
    input  VGND;

    wire A_inv, B_inv, A_B, A_inv_B_inv;
    wire xnor_out;

    assign A_inv = ~A;
    assign B_inv = ~B;
    assign A_B = A & B;
    assign A_inv_B_inv = A_inv & B_inv;

    // Simplify the XNOR operation using continuous assignment
    assign xnor_out = A ^ B; // XNOR can be represented as ~(A ^ B)
    
    assign Y = ~xnor_out;

endmodule