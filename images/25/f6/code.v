module logistic_regression (
    input [2:0] x,   // 3-bit input
    output reg [3:0] y // 4-bit output
);
    wire signed [5:0] weighted_sum; // 6-bit to handle the sum of the weights
    wire signed [5:0] sigmoid_value;

    assign weighted_sum = (2 * x[0]) + (3 * x[1]) + (5 * x[2]); // Weighted sum calculation

    // Sigmoid function approximation (1 / (1 + exp(-x))) can be approximated for small values
    // Here we will use a simple piecewise function for demonstration purposes
    always @(*) begin
        if (weighted_sum < -6) // mapping to output range
            y = 0;
        else if (weighted_sum < -3)
            y = 4;
        else if (weighted_sum < 0)
            y = 8;
        else if (weighted_sum < 3)
            y = 12;
        else
            y = 15;
    end
endmodule