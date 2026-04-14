module top_module(
	input clk,
	input [1:0] in,
	output reg [1:0] and_neg);reg [1:0] d_last;	
			
	always @(posedge clk) begin
		d_last <= in;
		and_neg <= in & ~d_last;
	end
	
endmodule