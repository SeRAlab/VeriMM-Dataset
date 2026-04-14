module top_module(S1_OUTPUT, S2_OUTPUT, S3_OUTPUT, S4_OUTPUT, S5_OUTPUT, S6_OUTPUT,
S7_OUTPUT, S8_OUTPUT, S_OUTPUT);input [0 : 3] S1_OUTPUT;
input [0 : 3] S2_OUTPUT;
input [0 : 3] S3_OUTPUT;
input [0 : 3] S4_OUTPUT;
input [0 : 3] S5_OUTPUT;
input [0 : 3] S6_OUTPUT;
input [0 : 3] S7_OUTPUT;
input [0 : 3] S8_OUTPUT;
output [1 : 32]S_OUTPUT;
wire [0 : 3] S1_OUTPUT;
wire [0 : 3] S2_OUTPUT;
wire [0 : 3] S3_OUTPUT;
wire [0 : 3] S4_OUTPUT;
wire [0 : 3] S5_OUTPUT;
wire [0 : 3] S6_OUTPUT;
wire [0 : 3] S7_OUTPUT;
wire [0 : 3] S8_OUTPUT;
wire [1 : 32]S_OUTPUT;
assign S_OUTPUT = {S1_OUTPUT,S2_OUTPUT,S3_OUTPUT,S4_OUTPUT,S5_OUTPUT,S6_OUTPUT,
S7_OUTPUT,S8_OUTPUT};endmodule