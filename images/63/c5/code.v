module top_module( A, B, C , M , Cout);input A,B,C;
	output M,Cout;
	assign {Cout,M} = A + B + C;endmodule