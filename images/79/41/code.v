module top_module(clk,rst,In,Out);input clk, rst;
	input[31:0] In;
	
	output[31:0] Out;
	reg[31:0] Out;
	
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			Out <= 32'd0;
		else
			Out <= In;
	end

endmodule