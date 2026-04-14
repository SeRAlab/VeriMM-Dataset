module register(
	input clk,
	input reset_n,
	input [31:0] d,
	output reg [31:0] q);
	
always @(negedge clk or negedge reset_n)
	if (!reset_n)
		q <= 32'b0;
	else
		q <= d;

endmodule