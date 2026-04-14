module top_module(
    input A,
    input B,
    input C,
    input D,
    input E,
    input F,
    output X
);wire nand1, nand2, nand3, nand4, nand5;

    assign nand1 = ~(A & B);
    assign nand2 = ~(C & D);
    assign nand3 = ~(E & F);
    assign nand4 = ~(nand1 & nand2);
    assign nand5 = ~(nand4 & nand3);
    assign X = nand5;

endmodule