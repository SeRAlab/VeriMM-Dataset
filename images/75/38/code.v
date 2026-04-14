module top_module(
    input A,
    input B,
    input SEL,
    output Y
);wire not_sel;
    wire nand1_out;
    wire nand2_out;

    nand nand1 (not_sel, SEL, SEL);
    nand nand2 (nand2_out, A, not_sel);
    nand nand3 (nand1_out, B, SEL);
    nand nand4 (Y, nand1_out, nand2_out);

endmodule