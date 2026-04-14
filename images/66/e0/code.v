module top_module(
    input  A,
    input  B,
    input  SEL,
    output Y
);wire nand1_out;
    wire nand2_out;
    wire nand3_out;
    wire nand4_out;

    // Implementing 2-to-1 MUX using NAND gates
    nand nand1 (nand1_out, A, SEL);
    nand nand2 (nand2_out, B, SEL);
    nand nand3 (nand3_out, nand1_out, SEL);
    nand nand4 (Y, nand2_out, nand3_out);

endmodule