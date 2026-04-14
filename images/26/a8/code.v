module logistic_regression(
    input wire [3:0] x1,  // 4-bit input
    input wire [3:0] x2,  // 4-bit input
    output wire y         // Output bit
);
    wire signed [5:0] weighted_sum; // 6-bit to hold weighted sum
    assign weighted_sum = (2 * x1) + (-1 * x2); // W1 * x1 + W2 * x2
    assign y = (weighted_sum >= 0) ? 1'b1 : 1'b0; // Thresholding
endmodule