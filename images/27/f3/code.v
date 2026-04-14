module KoggeStoneAdder (
    input [4:0] A,
    input [4:0] B,
    output [5:0] SUM
);
    wire [4:0] P; // Propagate
    wire [4:0] G; // Generate
    wire [4:0] C; // Carry

    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    // Carry computation using Kogge-Stone
    assign C[0] = 0; // No carry-in
    assign C[1] = G[0]; // C1 = G0
    assign C[2] = G[1] | (P[1] & G[0]); // C2 = G1 + P1*G0
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]); // C3
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]); // C4

    // Sum computation
    assign SUM = {C[4], P[4] ^ C[4], P[3] ^ C[3], P[2] ^ C[2], P[1] ^ C[1], P[0] ^ C[0]};

endmodule