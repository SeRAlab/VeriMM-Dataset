module top_module(
    A,
    B,
    C,
    D,
    Y
);input A;
    input B;
    input C;
    input D;
    output Y;

    wire nand1_out, nand2_out, nand3_out;

    // Using basic NAND gate logic for 4-input NAND
    assign nand1_out = ~(A & B);
    assign nand2_out = ~(nand1_out & C);
    assign nand3_out = ~(nand2_out & D);
    assign Y = nand3_out;

endmodule