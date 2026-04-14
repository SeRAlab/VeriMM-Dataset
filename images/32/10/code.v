module brent_kung_adder(
    input [3:0] A,
    input [3:0] B,
    output [4:0] SUM
);
    wire [4:0] G; // Generate signals
    wire [4:0] P; // Propagate signals
    wire [4:0] C; // Carry signals

    assign G = A & B; // Generate
    assign P = A ^ B; // Propagate

    // Carry calculations (Brent-Kung style)
    assign C[0] = 0; // C0 is always 0 for initial carry
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign SUM = P ^ C; // Final sum calculation

endmodule