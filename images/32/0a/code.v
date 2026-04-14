module kogge_stone_adder(
    input [3:0] A,
    input [3:0] B,
    output [4:0] S,
    output C_out
);
    wire [3:0] G; // Generate
    wire [3:0] P; // Propagate
    wire [3:0] C; // Carry

    // Generate and Propagate signals
    assign G = A & B; // Generate
    assign P = A ^ B; // Propagate

    // Carry signals
    assign C[0] = 0; // Initial carry-in is 0
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C_out = G[3] | (P[3] & C[3]);

    // Sum calculation
    assign S = P ^ C;

endmodule