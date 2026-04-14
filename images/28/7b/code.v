module brent_kung_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] SUM,
    output COUT
);
    wire [3:0] G, P; // Generate and Propagate
    wire [3:0] C;    // Carry bits

    // Generate and Propagate signals
    assign G = A & B; // Generate
    assign P = A ^ B; // Propagate

    // Carry generation
    assign C[0] = G[0];
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    // Sum calculation
    assign SUM = P ^ {C[2:0], 1'b0};
    assign COUT = C[3];

endmodule