module majority_nand(
    input A,
    input B,
    input C,
    output Y
);
    wire nand1, nand2, nand3, nand4, nand5;

    // NAND gates to create the combinational logic
    nand(nand1, A, B);
    nand(nand2, A, C);
    nand(nand3, B, C);
    nand(nand4, nand1, nand2);
    nand(nand5, nand3, nand4);
    nand(Y, nand5, nand5); // Final output Y

endmodule