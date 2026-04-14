module top_module(
	input clk,
	input [3:0] in,
	output reg [3:0] nedge);reg [3:0] d_last;

	always @(posedge clk) begin
		nedge <= ~in & d_last;
		d_last <= in;
	end
	
endmodule