module top_module(A, B, S, Z);input A, B, S;
output Z;

wire nand1_out, nand2_out, nand3_out, nand4_out;

nand nand1(nand1_out, A, S);
nand nand2(nand2_out, B, S);
nand nand3(nand3_out, nand1_out, S);
nand nand4(nand4_out, nand2_out, nand3_out);

nand Z_out(Z, nand4_out, nand4_out);

endmodule