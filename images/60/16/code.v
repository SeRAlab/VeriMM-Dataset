module top_module(
	input clk,
	input toggle,
	output reg q);always @(posedge clk) begin
		if (toggle)
			q <= ~q;
	end
	
endmodule