module top_module(
	input clk,
	input [2:0] in,
	output reg any_change);reg [2:0] d_last;	
			
	always @(posedge clk) begin
		d_last <= in;
		any_change <= |(in ^ d_last);
	end
	
endmodule