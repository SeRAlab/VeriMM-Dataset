module top_module(input 	reg [31:0] E_i
	,input 	reg [31:0] F_i
	,input 	reg [31:0] G_i
	
	,output reg [31:0] ch_o
	);assign ch_o = (E_i & F_i) ^ (~E_i & G_i);endmodule