module top_module(a, b, eq);input [4:0] a, b;
	output eq;
	
	wire q0, q1, q2, q3, q4;
	
	assign q0 = !(a[0] ^ b[0]);
	assign q1 = !(a[1] ^ b[1]);
	assign q2 = !(a[2] ^ b[2]);
	assign q3 = !(a[3] ^ b[3]);
	assign q4 = !(a[4] ^ b[4]);
	
	assign eq = q0 && q1 && q2 && q3 && q4;
	
endmodule