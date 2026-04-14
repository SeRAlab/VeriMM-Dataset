module top_module(
	input clk,
	input reset_n,
	input [63:0] in,
	output reg [63:0] out);reg [63:0] d_last;
			
	always @(posedge clk) begin
		d_last <= in;
		if (!reset_n)
			out <= '0;
		else
			out <= out | (~in & d_last);
	end
	
endmodule