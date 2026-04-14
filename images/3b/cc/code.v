module logistic_regression (
    input wire [3:0] x, // x1, x2, x3, x4
    output wire y
);
    wire signed [6:0] weighted_sum; // To accommodate the range of outputs
    assign weighted_sum = (2 * x[3]) + (-1 * x[2]) + (1 * x[1]) + (1 * x[0]); // w1*x1 + w2*x2 + w3*x3 + w4*x4
    assign y = (weighted_sum > 1) ? 1 : 0; // Thresholding
endmodule