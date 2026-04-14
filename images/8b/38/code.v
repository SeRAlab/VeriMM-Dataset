module top_module(
    Y,
    A,
    B
);// Module ports
    output Y;
    input  A;
    input  B;

    // Local signals
    wire and0_out_Y;
    wire nand0_out_Y;

    //  Name    Output      Other arguments
    nand nand0 (nand0_out_Y, A         );
    nand nand1 (and0_out_Y,  B         );
    nand nand2 (Y,          and0_out_Y );
    nand nand3 (and0_out_Y, nand0_out_Y, nand2_out_Y);

endmodule