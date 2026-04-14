module carry_lookahead_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [3:0] P; // Generate Propagate
    wire [3:0] G; // Generate
    wire [3:0] C; // Carry

    // Generate Propagate and Generate signals
    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    // Carry Lookahead Logic
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & P[0] & Cin);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & P[1] & P[0] & Cin);

    // Sum Output
    assign Sum = P ^ {C[2:0], Cin};
    assign Cout = C[3];
endmodule