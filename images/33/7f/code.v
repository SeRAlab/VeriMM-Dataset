module wallace_tree_adder (
    input [4:0] A,
    input [4:0] B,
    output [5:0] Sum
);
    wire [4:0] P; // Partial products
    wire [5:0] S; // Intermediate sums
    wire C1, C2;  // Carry signals

    // Generate partial products
    assign P[0] = A[0] & B[0];
    assign P[1] = A[1] & B[0];
    assign P[2] = A[2] & B[0];
    assign P[3] = A[3] & B[0];
    assign P[4] = A[4] & B[0];

    // Wallace Tree reduction (for 5 inputs, we will create two levels of reduction)
    assign S[0] = P[0];
    assign S[1] = P[1] ^ P[2];
    assign C1 = P[1] & P[2];
    assign S[2] = C1 ^ P[3];
    assign C2 = C1 & P[3];
    assign S[3] = C2 ^ P[4];
    
    assign Sum = {S[3], S[2], S[1], S[0]};
endmodule