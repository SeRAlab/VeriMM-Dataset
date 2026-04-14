module top_module (
	input [7:0] a,
	output [7:0] sum_and,
	output [7:0] sum_or);assign sum_and = {1'b0, a[7:1] & a[6:0]};
	assign sum_or = {a[6:0] | a[7:1], 1'b0};
	
endmodule