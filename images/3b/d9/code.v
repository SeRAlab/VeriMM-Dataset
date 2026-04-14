module logistic_regression (
    input wire [4:0] x, // 5 input features
    input wire b,       // bias term
    output wire y       // output classification
);
    wire [5:0] weighted_sum; // 6-bit sum to hold maximum value of 31
    assign weighted_sum = (x[0] * 1) + (x[1] * 2) + (x[2] * 3) + (x[3] * 4) + (x[4] * 5) + (b ? 1 : 0);
    assign y = (weighted_sum > 10) ? 1 : 0; // thresholding for logistic regression output
endmodule