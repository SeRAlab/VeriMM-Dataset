module carry_skip_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [3:0] P, G; // Propagate and Generate
    wire [3:0] S; // Intermediate sums
    wire carry_in; // Intermediate carry
    wire carry_skip; // Skip carry logic

    assign P = A ^ B; // Sum propagate
    assign G = A & B; // Generate carry

    // Calculate intermediate sum and carries
    assign S[0] = P[0] ^ Cin;
    assign carry_in = G[0] | (P[0] & Cin);
    
    assign S[1] = P[1] ^ carry_in;
    assign carry_in = G[1] | (P[1] & carry_in);
    
    assign S[2] = P[2] ^ carry_in;
    assign carry_in = G[2] | (P[2] & carry_in);
    
    assign S[3] = P[3] ^ carry_in;
    assign Cout = G[3] | (P[3] & carry_in);

    assign Sum = S;

endmodule