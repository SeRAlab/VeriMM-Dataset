module top_module(
	input clk,
	input [5:0] in,
	output reg [5:0] xor_prev);reg [5:0] d_last;	
			
	always @(posedge clk) begin
		d_last <= in;
		xor_prev <= in ^ d_last;
	end
	
endmodule