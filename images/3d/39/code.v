module CLA_4bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [3:0] G, P, C;

    // Generate and Propagate
    assign G = A & B;        // Generate
    assign P = A | B;        // Propagate

    // Carry calculation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[1]) | (P[2] & P[1] & P[0] & C[0]);

    // Sum calculation
    assign Sum = A ^ B ^ {C[2:0], Cin}; // Sum = A XOR B XOR Carry

    // Carry out
    assign Cout = C[3];

endmodule