module top_module(input	reg [31:0] E_i
	
	,output	reg [31:0] sigma_1_o
	);reg [31:0] E_6, E_11, E_25;
	assign E_6  = {E_i[5:0],  E_i[31:6]};
	assign E_11 = {E_i[10:0], E_i[31:11]};
	assign E_25 = {E_i[24:0], E_i[31:25]}; 
	assign sigma_1_o = (E_6) ^ (E_11) ^ (E_25);endmodule