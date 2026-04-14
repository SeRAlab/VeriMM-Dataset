module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S
);wire c1, c2, c3;
    wire [3:0] x1, x2, x3, x4, x5;
    
    // First stage
    assign x1 = A[0] ^ B[0];
    assign c1 = A[0] & B[0];
    
    // Second stage
    assign x2 = A[1] ^ B[1];
    assign c2 = A[1] & B[1];
    assign x3 = x1 ^ c1;
    wire c3_temp = x1 & c1; // Intermediate carry
    
    // Third stage
    assign x4 = A[2] ^ B[2];
    assign x5 = x2 & c3_temp;
    wire s3_temp = x3 ^ x5; // Sum bit
    wire c4_temp = x3 & x5; // Carry bit
    
    // Fourth stage
    assign S[0] = A[3] ^ B[3] ^ c4_temp;
    wire c5 = A[3] & B[3]; // Carry from A[3] and B[3]
    assign S[1] = s3_temp | c5; // Combine carry with sum for second bit
    assign S[2] = c3_temp | (x4 & c5); // S[2] as sum of carry bits for A[2]
    assign S[3] = c5; // Final carry out

endmodule