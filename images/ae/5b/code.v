module top_module(clk, rst_n, mem_result, sprite_ALU_result, mem_ALU_select, 
		  reg_WB_data);input clk, rst_n, mem_ALU_select;
	input [31:0] mem_result, sprite_ALU_result;
	output [31:0] reg_WB_data;
		  
	assign reg_WB_data = (mem_ALU_select) ?  mem_result : sprite_ALU_result;

endmodule