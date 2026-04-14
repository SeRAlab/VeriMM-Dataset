module top_module (
	input clk,
	input u,
	input v,
	output reg w,
	output reg state);reg h;
	always @(posedge clk)
		h <= u&v | u&h | v&h;
	
	assign w = u^v^h;
	assign state = h;
			
endmodule