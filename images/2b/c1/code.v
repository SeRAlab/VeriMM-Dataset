module logistic_regression(
    input [4:0] features,
    output reg prediction
);
    wire [7:0] weighted_sum;

    // Fixed weights
    assign weighted_sum = (features[0] ? 2 : 0) +
                          (features[1] ? 5 : 0) +
                          (features[2] ? 6 : 0) +
                          (features[3] ? 3 : 0) +
                          (features[4] ? 4 : 0);

    // Threshold for prediction
    always @(*) begin
        if (weighted_sum > 10) // Threshold
            prediction = 1;
        else
            prediction = 0;
    end
endmodule