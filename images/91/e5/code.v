module top_module(
    Y,
    A,
    B,
    C,
    D,
    VPWR,
    VGND
);output Y;
    input A, B, C, D, VPWR, VGND;

    wire nand1_out, nand2_out, nand3_out;

    // Instantiate NAND gate using basic gates instead
    wire nand1_out_n, nand2_out_n, nand3_out_n;

    assign nand1_out = ~(A & B);
    assign nand2_out = ~(C & D);
    assign nand3_out = ~(nand1_out & nand2_out);

    // Final NAND gate to produce the output Y
    assign Y = ~(nand3_out & nand3_out);

endmodule