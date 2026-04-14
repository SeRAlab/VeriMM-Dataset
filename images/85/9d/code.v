module top_module(
	input clk,
	input [4:0] in,
	output reg [4:0] or_prev);reg [4:0] d_last;	
			
	always @(posedge clk) begin
		d_last <= in;
		or_prev <= in | d_last;
	end
	
endmodule