module top_module(
	input clk,
	input [3:0] in,
	output reg [3:0] edge);reg [3:0] d_last;	
			
	always @(posedge clk) begin
		d_last <= in;
		edge <= in ^ d_last;
	end
	
endmodule