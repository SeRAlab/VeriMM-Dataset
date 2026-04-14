module top_module(
	input clk,
	input [3:0] in,
	output reg [3:0] nedge_clear);reg [3:0] d_last;	
			
	always @(posedge clk) begin
		d_last <= in;
		nedge_clear <= ~in & d_last;
	end
	
endmodule