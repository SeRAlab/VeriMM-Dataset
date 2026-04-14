module top_module(
    input a,
    input b,
    output y
);wire nand1, nand2;

    // Implement NAND gates for AND logic
    nand nand_inst1 (nand1, a, b);
    nand nand_inst2 (nand2, nand1, nand1);
    nand nand_inst3 (y, nand2, nand2);

endmodule