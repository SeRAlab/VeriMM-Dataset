module top_module(left, right, A, shift_amount);input [63:0] A;
	input [5:0] shift_amount;
	output[63:0] left, right;
	
	assign left = A << shift_amount;
	assign right = A >> shift_amount;endmodule