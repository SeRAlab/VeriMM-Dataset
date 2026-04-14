module top_module(
		input  wire  clk_0_clk,              
		input  wire  clk_1_clk,              
		output wire  clock_25_clk,           
		output wire  clock_25_reset_reset_n, 
		output wire  clock_27_clk_clk,       
		output wire  clock_27_reset_reset_n, 
		input  wire  reset_0_reset_n,        
		input  wire  reset_1_reset_n         
	);assign clock_27_clk_clk = clk_0_clk;

	assign clock_25_clk = clk_1_clk;

	assign clock_27_reset_reset_n = reset_0_reset_n;

	assign clock_25_reset_reset_n = reset_1_reset_n;

endmodule