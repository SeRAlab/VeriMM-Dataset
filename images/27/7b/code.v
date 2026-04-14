module logistic_regression (
    input wire x1,
    input wire x2,
    output wire y
);
    wire signed [3:0] weighted_sum;
    
    assign weighted_sum = x1 + x2; // Using W1 = 1 and W2 = 1
    assign y = (weighted_sum >= 0) ? 1 : 0; // Simple thresholding for logistic output approximation
endmodule