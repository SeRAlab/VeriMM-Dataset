module top_module(
	input clk,
	input reset,
	input in,
	output reg out);reg d_last;
			
	always @(posedge clk or posedge reset) begin
		if (reset)
			out <= 0;
		else begin
			d_last <= in;
			out <= out | (~in & d_last);
		end
	end
	
endmodule