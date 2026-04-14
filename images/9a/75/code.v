module top_module(
	input clk,
	input reset,
	input [15:0] in,
	output reg [15:0] out);reg [15:0] d_last;
reg [15:0] d_last2;
reg [15:0] d_last3;

	always @(posedge clk) begin
		d_last3 <= d_last2;
		d_last2 <= d_last;
		d_last <= in;
		if (reset)
			out <= '1;
		else
			out <= out & ~(in & d_last & d_last2 & d_last3);
	end
	
endmodule