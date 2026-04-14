module top_module(x, sum, carry);output sum,carry;
input [2:0] x;

wire w;	
	assign 	 w = x[2] ^ x[1];
        assign	 sum = w ^ x[0];
	assign 	 carry = (x[2] & x[1])|(w & x[0]);endmodule