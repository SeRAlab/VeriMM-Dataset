module logistic_regression (
    input [7:0] feature1,
    input [7:0] feature2,
    input [7:0] weight1,
    input [7:0] weight2,
    output reg result
);

    wire signed [15:0] weighted_sum;
    reg signed [15:0] threshold;

    assign weighted_sum = (feature1 * weight1) + (feature2 * weight2);
    always @(*) begin
        threshold = 128; // A threshold for logistic regression
        if (weighted_sum > threshold)
            result = 1'b1;
        else
            result = 1'b0;
    end
endmodule