module KoggeStoneAdder(
    input [4:0] A,
    input [4:0] B,
    output [4:0] Sum,
    output Cout
);
    wire [4:0] P; // Propagate
    wire [4:0] G; // Generate
    wire [4:0] C; // Carry

    // Generate and Propagate
    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    // Carry computation
    assign C[0] = G[0];
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);

    // Sum computation
    assign Sum = P ^ C;

    // Carry out
    assign Cout = C[4];

endmodule