module binary_adder (
	input clk,
	input [3:0] a,
	input [3:0] b,
	input carry_in,
	output reg [3:0] sum,
	output reg carry_out);always @(posedge clk) begin
	{carry_out, sum} <= a + b + carry_in;
end

endmodule