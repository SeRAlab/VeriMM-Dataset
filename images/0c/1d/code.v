module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] P; // Propagate
    wire [3:0] G; // Generate
    wire [4:0] C; // Carry

    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    assign C[0] = Cin; // Carry-in
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);

    assign S = P ^ C[3:0]; // Sum
    assign Cout = C[4]; // Carry-out
endmodule