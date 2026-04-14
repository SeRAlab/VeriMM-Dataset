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
    wire inv_A_out;
    wire nand0_out_Y;

    // Instantiate inverter logic
    not inv_A (inv_A_out, A); // Changed inv to not

    // Instantiate NAND gate logic
    nand nand0 (nand0_out_Y, D, C, B, inv_A_out);
    
    // Instantiate buffer
    buf buf0 (Y, nand0_out_Y);

endmodule