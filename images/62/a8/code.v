module top_module(
    A,
    B,
    Y
);// Module ports
    input  A;
    input  B;
    output Y;

    // Local signals
    wire nand1_out;
    wire nand2_out;

    // NAND gates
    nand nand1 (nand1_out, A, B);
    nand nand2 (Y, nand1_out, nand1_out);

endmodule