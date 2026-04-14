module brent_kung_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] SUM,
    output COUT
);
    wire [3:0] G; // Generate
    wire [3:0] P; // Propagate
    wire [4:0] C; // Carry

    assign G = A & B; // Generate
    assign P = A ^ B; // Propagate

    assign C[0] = 0; // C0 is 0
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign SUM = P ^ C[3:0]; // Sum calculation
    assign COUT = C[4]; // Carry out

endmodule