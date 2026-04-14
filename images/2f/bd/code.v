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

    // Calculate carries
    assign C[0] = G[0];
    assign C[1] = G[1] | (P[1] & G[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]);

    // Calculate sum
    assign SUM = {C[4], P ^ C};

endmodule