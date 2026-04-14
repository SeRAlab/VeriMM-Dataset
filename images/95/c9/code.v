module top_module(A, B, S, Y);input A;
input B;
input S;
output Y;

wire nand1_out;
wire nand2_out;
wire nand3_out;

nand nand1 (nand1_out, A, S);
nand nand2 (nand2_out, B, !S);
nand nand3 (Y, nand1_out, nand2_out);

endmodule