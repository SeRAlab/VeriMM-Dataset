module CarrySkipAdder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Skip,
    output [3:0] S,
    output Cout
);

wire [3:0] P; // Propagate
wire [3:0] G; // Generate
wire [4:0] C; // Carry bits

assign P = A ^ B; // Propagate
assign G = A & B; // Generate

// Carry generation
assign C[0] = Cin;
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & C[1]);
assign C[3] = G[2] | (P[2] & C[2]);
assign C[4] = G[3] | (P[3] & C[3]);

// Sum calculation
assign S = P ^ {C[3:1], Cin};

// Carry-out logic with Skip
assign Cout = Skip ? C[0] : C[4];

endmodule