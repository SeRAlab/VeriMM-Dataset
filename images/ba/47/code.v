module top_module(
    input A,
    input B,
    input C,
    output Y
);wire nand_AB, nand_Y;

    // Use Verilog built-in NAND gate instead of the missing sky130_fd_sc_ms__nand2_1
    assign nand_AB = ~(A & B);
    assign nand_Y = ~(nand_AB & C);

    assign Y = nand_Y;

endmodule