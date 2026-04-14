module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0]S,
    output PG,
    output GG,
    output Cout
    );wire [3:0] P;
	wire [3:0] G;
	wire [3:0] C;
	
	assign P[3:0] = A[3:0] ^ B[3:0];
	assign G[3:0] = A[3:0] & B[3:0];
	assign C[0] = G[0] | ( P[0] & Cin );
	assign C[3:1] = G[3:1] | ( P[3:1] & C[3:0] );
	assign S[0] = P[0] ^ Cin;
	assign S[3:1] = P[3:1] ^ C[3:0];
	assign Cout = C[3];
	
	assign PG = P[0] & P[1] & P[2] & P[3];
	assign GG = G[3] | ( G[2] & P[3] ) | ( G[1] & P[2] & P[3] ) | ( G[0] & P[1] & P[2] & P[3] );

endmodule