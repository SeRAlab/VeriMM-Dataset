module KoggeStoneAdder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] SUM,
    output COUT
);
    wire [3:0] P, G, C;
    wire [4:0] C_temp;

    assign P = A ^ B; // Generate Propagate
    assign G = A & B; // Generate Generate

    assign C_temp[0] = 0; // Initial carry
    assign C_temp[1] = G[0]; // Carry for bit 1
    assign C_temp[2] = G[1] | (P[1] & C_temp[1]); // Carry for bit 2
    assign C_temp[3] = G[2] | (P[2] & C_temp[2]); // Carry for bit 3
    assign C_temp[4] = G[3] | (P[3] & C_temp[3]); // Carry for bit 4 (COUT)

    assign SUM = P ^ C_temp[3:0]; // Compute the sum
    assign COUT = C_temp[4]; // Final carry out

endmodule