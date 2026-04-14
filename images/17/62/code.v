module KoggeStoneAdder (
    input [3:0] A,
    input [3:0] B,
    output [4:0] Sum
);

wire [3:0] G; // Generate
wire [3:0] P; // Propagate
wire [3:0] C; // Carry

// Generate and Propagate
assign G = A & B;        // Generate
assign P = A ^ B;        // Propagate

// Carry computation
assign C[0] = 0;         // No carry-in for the first bit
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);

// Final sum output
assign Sum[0] = P[0] ^ C[0];
assign Sum[1] = P[1] ^ C[1];
assign Sum[2] = P[2] ^ C[2];
assign Sum[3] = P[3] ^ C[3];
assign Sum[4] = G[3] | (P[3] & C[3]);

endmodule