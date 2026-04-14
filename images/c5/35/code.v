module xor_nand (
    input a,
    input b,
    output reg out
);

    assign nand1 = ~(a & b);
    assign nand2 = ~(nand1 & nand1);
    assign out = nand2;

endmodule