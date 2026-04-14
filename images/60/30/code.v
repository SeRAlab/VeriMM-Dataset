module top_module(
	input clk_in,
	input reset,
	output clk_out
	);reg CLK2=0;
	reg CLK4=0;

	always @(posedge clk_in) begin 
		if(reset)
			CLK2=0;
		else
			CLK2=~CLK2;
	end
	always @(posedge CLK2) begin 
		if(reset)
			CLK4=0;
		else
			CLK4=~CLK4;
	end

	assign clk_out = CLK4;

endmodule