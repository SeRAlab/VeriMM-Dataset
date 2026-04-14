module top_module(A, B, Cin, Sum, P, G);input A, B, Cin;
	
	output Sum, P, G;
	wire P_int;
	

	
	assign G = A & B;
	
	assign P_int = A ^ B;
	assign P = P_int;
	
	assign Sum = P_int ^ Cin;

endmodule