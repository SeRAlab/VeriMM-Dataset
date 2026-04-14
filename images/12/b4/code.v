module brent_kung_adder (
    input [4:0] A,
    input [4:0] B,
    output [4:0] SUM,
    output C_out
);
    wire [4:0] P; // Generate signals
    wire [4:0] G; // Propagate signals
    wire [4:0] C; // Carry signals

    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    assign C[0] = 0; // Initial carry
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign SUM = P ^ C[4:0];
    assign C_out = C[4];

endmodule