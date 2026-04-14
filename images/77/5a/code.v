module top_module(
	input clk,
	input reset_n,
	input [31:0] in,
	output reg [31:0] out);reg [31:0] d_last;
reg [31:0] d_last2;

	always @(posedge clk) begin
		d_last2 <= d_last;
		d_last <= in;
		if (!reset_n)
			out <= '1;
		else
			out <= out & ~(~d_last & d_last2 & in);
	end
	
endmodule