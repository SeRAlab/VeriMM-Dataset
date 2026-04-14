module carry_skip_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] P; // Propagate
    wire [3:0] G; // Generate
    wire C2, C3; // Intermediate carry signals

    // Generate and Propagate
    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    // Carry generation logic
    assign C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C3 = G[2] | (P[2] & C2);
    
    // Sum outputs
    assign S = P ^ {C3, C2, Cin, 1'b0}; // Sum calculation including carry
    assign Cout = G[3] | (P[3] & C3); // Final carry-out

endmodule