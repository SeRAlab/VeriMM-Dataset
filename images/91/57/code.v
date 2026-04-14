module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);wire [3:0] G; // Generate signals (A AND B)
    wire [3:0] P; // Propagate signals (A XOR B)
    wire [3:0] C; // Carry signals

    // Generate and Propagate
    assign G = A & B; // AND operation
    assign P = A ^ B; // XOR operation

    // Carry logic
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);

    // Sum logic
    assign S[0] = P[0] ^ C[0];
    assign S[1] = P[1] ^ C[1];
    assign S[2] = P[2] ^ C[2];
    assign S[3] = P[3] ^ C[3];

    // Carry Out
    assign Cout = G[3] | (P[3] & C[3]);

endmodule