module top_module(
    A,
    B,
    EQ,
    GT
);input [3:0] A;
    input [3:0] B;
    output EQ;
    output GT;

    wire [3:0] A_xor_B;
    wire [3:0] A_and_B;
    wire A_gt_B_0; // change to single bit
    wire A_gt_B_1; // change to single bit
    wire A_gt_B;

    assign A_xor_B = A ^ B; // Simplified XOR logic using bitwise operator

    assign A_and_B = A & B; // Simplified AND logic using bitwise operator

    assign A_gt_B_0 = A_and_B[0] | A_and_B[1]; // Combine results
    assign A_gt_B_1 = A_and_B[2] | A_and_B[3]; // Combine results

    assign EQ = ~(A_gt_B_0 | A_gt_B_1); // Logic for equality
    assign GT = A_gt_B_0 & A_gt_B_1; // Logic for greater than

endmodule