module dot_product (
    input [4:0] A, // 5-bit vector A
    input [4:0] B, // 5-bit vector B
    output [9:0] P // 10-bit output for the dot product
);
    assign P = A[0]*B[0] + A[1]*B[1] + A[2]*B[2] + A[3]*B[3] + A[4]*B[4]; // Dot product calculation
endmodule