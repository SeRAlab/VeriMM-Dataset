module top_module(A, B, Cin, sum, Cout, Pout, Gout);input  [3:0] A, B; 
	input  Cin;			
	output [3:0] sum; 
	output Cout;
	output Pout, Gout; 
	
	wire [3:0] G, P, carryOut;
	
	assign G = A & B; 
	assign P = A ^ B; 
	
	assign carryOut[0] = G[0] | (P[0] & Cin);
	
	
	assign carryOut[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
	
	
	assign carryOut[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
	
	
	assign carryOut[3] = G[3] | (P[3] & G[2]) | 
									(P[3] & P[2] & G[1]) | 
									(P[3] & P[2] & P[1] & G[0]) | 
									(P[3] & P[2] & P[1] & P[0] & Cin);	
	assign Cout = carryOut[3];
	assign sum = P ^ {carryOut[2:0], Cin};
	assign Pout = P[3] & P[2] & P[1] & P[0];
	assign Gout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);endmodule