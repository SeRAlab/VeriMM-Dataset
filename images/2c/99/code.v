module kogge_stone_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output Cout
);
    wire [3:0] P; // Generate
    wire [3:0] G; // Propagate
    wire [3:0] C; // Carry

    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    assign C[0] = G[0]; // First carry
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    assign S = P ^ C; // Sum
    assign Cout = C[3]; // Carry out

endmodule