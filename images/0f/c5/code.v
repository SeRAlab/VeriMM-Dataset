module carry_skip_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [3:0] P; // Propagate
    wire [3:0] G; // Generate
    wire [3:0] C; // Carry
    wire skip;     // Skip signal

    // Propagate and Generate signals
    assign P = A ^ B; // P = A + B
    assign G = A & B; // G = A * B

    // Carry calculation
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    assign skip = (G[0] & P[0]) | (G[1] & P[1] & P[0]) | (G[2] & P[2] & P[1] & P[0]);
    
    assign Cout = G[3] | (P[3] & C[2]) | (skip & Cin);
    
    // Sum calculation
    assign Sum = P ^ {C[2:0], Cin};

endmodule