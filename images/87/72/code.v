module top_module(
	input clk,
	input reset,
	input [127:0] in,
	output reg [127:0] out);reg [127:0] d_last;
			
	always @(posedge clk) begin
		d_last <= in;
		if (reset)
			out <= '0;
		else
			out <= out | (~in & d_last);
	end
	
endmodule