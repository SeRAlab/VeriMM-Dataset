module top_module (
	input [7:0] a,
	output [6:0] out_sum,
	output [6:0] out_and,
	output [7:0] out_xor);assign out_sum = a[6:0] + a[7:1];
	assign out_and = a[6:0] & a[7:1];
	assign out_xor = a ^ {a[0], a[7:1]};
	
endmodule