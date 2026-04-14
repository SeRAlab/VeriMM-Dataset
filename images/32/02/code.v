module logistic_regression (
    input wire x1,
    input wire x2,
    input wire x3,
    output wire y
);
    wire [2:0] weighted_sum;

    // Calculate weighted sum
    assign weighted_sum = x1 + x2 + x3;

    // Apply the threshold (let's say the threshold is 1)
    assign y = (weighted_sum > 1) ? 1'b1 : 1'b0;

endmodule