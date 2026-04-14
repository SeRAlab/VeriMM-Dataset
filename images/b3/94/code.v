module comparator2bit (
	input clk,
	input [1:0] a,
	input [1:0] b,
	output reg a_gt_b,
	output reg a_lt_b,
	output reg a_eq_b);

	always @(posedge clk) begin
		a_gt_b <= (a > b);
		a_lt_b <= (a < b);
		a_eq_b <= (a == b);
	end
	
endmodule