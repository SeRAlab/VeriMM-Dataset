module top_module( clk, reset, d, q );// synthesis attribute keep_hierarchy dffr_9 "true";
	input clk;
	input reset;
	input [8:0] d;
	output [8:0] q;
	reg [8:0] q;
	
	always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 9'b0;
		else
			q <= d;
	end
endmodule