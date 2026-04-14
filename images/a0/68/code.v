module top_module(A, B, C, D, Z);input A;
input B;
input C;
input D;
output [1:0] Z;

wire [1:0] nand1_out;
wire [1:0] nand2_out;
wire [1:0] nand3_out;

nand nand1(nand1_out[0], A, B);
nand nand2(nand2_out[0], C, D);
nand nand3(nand3_out[0], nand1_out[0], nand2_out[0]);
nand nand4(Z[1], nand3_out[0], nand3_out[0]);
nand nand5(Z[0], nand4, nand4);

endmodule