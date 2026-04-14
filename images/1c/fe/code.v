module carry_skip_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] P; // Propagate
    wire [3:0] G; // Generate
    wire [3:0] C; // Carry

    // Generate and Propagate signals
    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate
    assign C[0] = G[0] | (P[0] & Cin);
    
    // Generate subsequent carry bits
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    // Sum output
    assign S = P ^ {C[2:0], Cin};
    assign Cout = C[3];

endmodule