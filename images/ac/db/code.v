module top_module(x, sum, carry);output sum,carry;
input [1:0] x;

	assign	 sum = x[1] ^ x[0];
	assign 	 carry = x[1] & x[0];endmodule