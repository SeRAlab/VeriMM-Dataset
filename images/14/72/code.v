module logistic_regression (
    input [4:0] features,
    input [2:0] weights,
    output reg result
);
    wire signed [7:0] weighted_sum;
    
    // Compute the weighted sum
    assign weighted_sum = (features[0] * weights[0]) + 
                          (features[1] * weights[1]) + 
                          (features[2] * weights[2]) + 
                          (features[3] * weights[0]) + 
                          (features[4] * weights[1]);
    
    // Apply the logistic function (simplified for demonstration)
    always @(*) begin
        if (weighted_sum > 4) // threshold for decision
            result = 1;
        else
            result = 0;
    end
endmodule