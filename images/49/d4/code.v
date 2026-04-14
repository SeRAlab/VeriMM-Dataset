module top_module(
	input clk,
	input reset_n,
	input [15:0] in,
	output reg [15:0] out);reg [15:0] d_last;

	always @(posedge clk) begin
		d_last <= in;
		if (!reset_n)
			out <= '1;
		else
			out <= out & ~(in & ~d_last);
	end
	
endmodule