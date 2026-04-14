module top_module(
    input a,
    input b,
    input c,
    input sel_2to1,
    input sel_3to1,
    output reg out
);wire nand1, nand2, nand3, nand4, nand5, nand6;

assign nand1 = ~(a & sel_2to1);
assign nand2 = ~(b & ~sel_2to1);
assign nand3 = ~(nand1 & nand2);

assign nand4 = ~(nand3 & sel_3to1);
assign nand5 = ~(c & ~sel_3to1);
assign nand6 = ~(nand4 & nand5);

assign out = ~nand6;

endmodule