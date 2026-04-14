module top_module(
    Y,
    A,
    B,
    C,
    D
);// Module ports
    output Y;
    input  A;
    input  B;
    input  C;
    input  D;

    // Local signals
    wire and0_out_Y;
    wire and1_out_Y;

    //  Name  Output      Other arguments
    and and0 (and0_out_Y, A, B           );
    and and1 (and1_out_Y, C, D           );
    and and2 (Y         , and0_out_Y, and1_out_Y);

endmodule