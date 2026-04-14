module top_module(G, P, Ci, C, Co, PG, GG);input [3:0] G, P;
	input Ci;
	output [3:1] C;
	output Co, PG, GG;

	wire GG_int, PG_int;
	
	
	assign C[1] = G[0] | (P[0] & Ci);
	
	assign C[2]= G[1] | (P[1] & G[0]) | (P[1] & P[0] & Ci);
	
	assign C[3]= G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Ci);
	
	
	assign GG_int = G[3] | (P[3] & G[2]) |(P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
	
	assign PG_int = P[3] & P[2] & P[1] & P[0] & Ci;
	assign GG = GG_int;
	assign PG = PG_int;
	assign Co = GG_int | (PG_int & Ci);endmodule