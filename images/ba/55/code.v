module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);wire n1, n2, n3;

    // 2-input NAND gates
    nand nand1(n1, A, B);
    nand nand2(n2, C, D);
    nand nand3(Y, n1, n2);

endmodule