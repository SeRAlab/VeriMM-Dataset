module logistic_regression (
    input [7:0] feature1,
    input [7:0] feature2,
    output reg prediction
);
    // Fixed weights and bias
    parameter weight1 = 3;
    parameter weight2 = 5;
    parameter bias = -10;

    reg signed [15:0] z; // To hold the weighted sum
    
    always @(*) begin
        z = (weight1 * feature1) + (weight2 * feature2) + bias;
        prediction = (z > 0) ? 1'b1 : 1'b0; // Simple thresholding
    end
endmodule