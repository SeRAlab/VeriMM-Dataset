module top_module(
    input A,
    input B,
    input C,
    input D,
    input VPWR,
    input VGND,
    output Y
);// Create internal signals
    wire nand1;
    wire nand2;
    wire nand3;

    // Implement NAND gate
    assign nand1 = ~(A & B);
    assign nand2 = ~(C & D);
    assign nand3 = ~(nand1 & nand2);
    assign Y = nand3;

endmodule