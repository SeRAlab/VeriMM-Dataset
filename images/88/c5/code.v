module top_module (
	input clk,
	input a,
	input b,
	output reg o,
	output reg state1,
	output reg state2);always @(posedge clk)
begin
	state1 <= a & ~b;
	state2 <= a & b;
end

assign o = state1 & state2;

endmodule