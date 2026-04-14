module brent_kung_adder (
    input [3:0] A,
    input [3:0] B,
    output [4:0] SUM
);
    wire [3:0] G; // Generate
    wire [3:0] P; // Propagate
    wire [3:0] C; // Carry

    // Generate and Propagate signals
    assign G = A & B; // G = A AND B
    assign P = A ^ B; // P = A XOR B

    // Carry signals
    assign C[0] = G[0]; // C0 = G0
    assign C[1] = G[1] | (P[1] & G[0]); // C1 = G1 + (P1 * G0)
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]); // C2 = G2 + (P2 * G1) + (P2 * P1 * G0)
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]); // C3 = G3 + (P3 * G2) + ...

    // Sum calculation
    assign SUM = {C[3], P[3], P[2] ^ C[2], P[1] ^ C[1], P[0] ^ C[0]}; // SUM = C3 + P3 + (P2 XOR C2) + (P1 XOR C1) + (P0 XOR C0)
endmodule