module top_module(
	input clk,
	input [2:0] in,
	output reg [2:0] pedge);reg [2:0] d_last;

	always @(posedge clk) begin
		d_last <= in;
		pedge <= in & ~d_last;
	end
	
endmodule