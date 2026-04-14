module logistic_regression (
    input [7:0] x1,
    input [7:0] x2,
    output reg y
);
    wire [15:0] weighted_sum;
    wire [15:0] sigmoid_output;

    // Weights
    localparam w1 = 2'b01;
    localparam w2 = 2'b01;

    // Calculate weighted sum
    assign weighted_sum = (w1 * x1) + (w2 * x2);
    
    // Sigmoid approximation: y = 1 / (1 + exp(-z))
    // Here we approximate sigmoid using a simple threshold
    always @(*) begin
        if (weighted_sum[15:8] >= 8'd128) // threshold 0.5
            y = 1;
        else
            y = 0;
    end
endmodule