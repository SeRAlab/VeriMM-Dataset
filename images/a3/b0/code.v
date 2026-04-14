module top_module(input 	reg [31:0] A_i
	,input 	reg [31:0] B_i
	,input 	reg [31:0] C_i
	
	,output reg [31:0] maj_o
	);assign maj_o = (A_i & B_i) ^ (A_i & C_i) ^ (B_i & C_i);endmodule