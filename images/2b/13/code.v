module CLA_4bit (
    input [3:0] A, // 4-bit input A
    input [3:0] B, // 4-bit input B
    input Cin,     // Carry input
    output [3:0] S, // 4-bit sum output
    output Cout    // Carry output
);
    wire [3:0] P; // Propagate
    wire [3:0] G; // Generate
    wire [3:0] C; // Carry bits

    // Generate and propagate signals
    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    // Carry generation
    assign C[0] = G[0] | (P[0] & Cin); // Carry out from bit 0
    assign C[1] = G[1] | (P[1] & C[0]); // Carry out from bit 1
    assign C[2] = G[2] | (P[2] & C[1]); // Carry out from bit 2
    assign C[3] = G[3] | (P[3] & C[2]); // Carry out from bit 3

    // Sum generation
    assign S = P ^ {C[2:0], Cin}; // Sum output
    assign Cout = C[3]; // Final carry out

endmodule