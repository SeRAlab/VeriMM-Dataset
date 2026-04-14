module KoggeStoneAdder(
    input [3:0] A,
    input [3:0] B,
    output [3:0] SUM,
    output COUT
);
    wire [3:0] G, P, C;

    assign G = A & B;  // Generate
    assign P = A ^ B;  // Propagate

    assign C[0] = 0; // Initial carry-in
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign COUT = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign SUM = P ^ C;

endmodule