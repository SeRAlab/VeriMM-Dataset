module Brent_Kung_Adder(
    input [3:0] A,
    input [3:0] B,
    output [4:0] SUM
);
    wire [3:0] P; // propagate
    wire [3:0] G; // generate
    wire [3:0] C; // carry

    assign P = A ^ B; // propagate
    assign G = A & B; // generate

    // Carry calculations using Brent-Kung logic
    assign C[0] = 0; // no carry-in for the first stage
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);

    // Compute sum
    assign SUM = {C[3], P[3], P[2] ^ C[2], P[1] ^ C[1], P[0] ^ C[0]};
endmodule