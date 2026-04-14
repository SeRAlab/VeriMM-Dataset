module carry_skip_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] P; // Propagate
    wire [3:0] G; // Generate
    wire C1, C2, C3; // Carry bits

    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & C1);
    assign C3 = G[2] | (P[2] & C2);
    assign Cout = G[3] | (P[3] & C3);

    assign S = P ^ {C2, C1, Cin, 1'b0};

endmodule