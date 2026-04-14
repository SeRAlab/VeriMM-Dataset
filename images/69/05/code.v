module top_module(V, M, z);input [3:0] V;
	output [3:0] M;
	output z;

	wire[2:0] B;
	
	
	assign z = (V[3] & V[2]) | (V[3] & V[1]);

	
	assign B[2] = V[2] & V[1];
	assign B[1] = V[2] & ~V[1];
	assign B[0] = (V[1] & V[0]) | (V[2] & V[0]);

	
	assign M[3] = ~z & V[3];
	assign M[2] = (~z & V[2]) | (z & B[2]);
	assign M[1] = (~z & V[1]) | (z & B[1]);
	assign M[0] = (~z & V[0]) | (z & B[0]);
endmodule