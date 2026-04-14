module top_module(C, G, P, C0);output wire [4:1] C; 
  input wire [3:0] G, P; 
  input wire C0; 
	
  assign #2 C[1] = G[0] | (P[0] & C0);
  assign #2 C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C0);
  assign #2 C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0])
	 | (P[2] & P[1] & P[0] & C0);
  assign #2 C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1])
	 | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1]
	 & P[0] & C0);
endmodule