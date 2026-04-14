module top_module(input 	reg [31:0] A_i
	
	,output reg [31:0] sigma_0_o
	);reg [31:0] A_2, A_13, A_22;
	assign A_2 	= {A_i[1:0],  A_i[31:2]};
	assign A_13 	= {A_i[12:0], A_i[31:13]};
	assign A_22 	= {A_i[21:0], A_i[31:22]};
	assign sigma_0_o = (A_2) ^ (A_13) ^ (A_22);endmodule