module xor_gate(
    input a,
    input b,
    input c,
    output out
);

wire nand1, nand2, nand3, nand4, nand5;

assign nand1 = ~(a & b);
assign nand2 = ~(a & nand1);
assign nand3 = ~(b & nand1);
assign nand4 = ~(c & nand2);
assign nand5 = ~(nand1 & nand3);

assign out = ~(nand4 & nand5);

endmodule