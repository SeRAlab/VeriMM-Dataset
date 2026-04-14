module CLA_4bit (
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C_out
);
    wire [3:0] G; // Generate
    wire [3:0] P; // Propagate
    wire [4:0] C; // Carry

    assign G = A & B; // Generate
    assign P = A ^ B; // Propagate

    assign C[0] = 1'b0; // Initial carry is 0
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    
    assign S = P ^ C[3:0]; // Sum

endmodule