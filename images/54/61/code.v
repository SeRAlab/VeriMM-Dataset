module top_module( 
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);wire nand1, nand2, nand3, nand4, nand5, nand6, nand7, nand8, nand9, nand10, nand11, nand12, nand13;

assign nand1 = ~(in[0] & in[1]);
assign nand2 = ~(in[2] & in[3]);
assign nand3 = ~(in[0] & in[2]);
assign nand4 = ~(in[1] & in[3]);
assign nand5 = ~(in[0] & in[3]);
assign nand6 = ~(in[1] & in[2]);
assign nand7 = ~(nand1 & nand2);
assign nand8 = ~(nand3 & nand4);
assign nand9 = ~(nand5 & nand6);
assign nand10 = ~(nand7 & nand8);
assign nand11 = ~(nand7 & nand9);
assign nand12 = ~(nand8 & nand9);
assign nand13 = ~(nand10 & nand11 & nand12);

assign out_and = ~(nand10);
assign out_or = ~(nand13);
assign out_xor = ~(nand11 & nand12);

endmodule