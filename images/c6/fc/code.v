module nand_and_gate (
    input A,
    input B,
    output Y
);

wire nand1_out;
wire nand2_out;

nand nand1 (nand1_out, A, B);
nand nand2 (Y, nand1_out, nand1_out);

endmodule