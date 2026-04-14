module top_module(
	input clk,
	input set,
	input reset,
	input s,
	input r,
	output reg q);always @(posedge clk or posedge set or posedge reset) begin
	if (reset)
		q <= 1'b0;
	else if (set)
		q <= 1'b1;
	else if (s && ~r)
		q <= 1'b1;
	else if (~s && r)
		q <= 1'b0;
end
endmodule