module top_module(x, q, z);input x;
	input [1:0] q;
	output z;
	
	assign z = x * q[0] * q[1];

endmodule