module neural_network_layer (
    input [1:0] x1,
    input [1:0] x2,
    output reg y
);
    // Hardcoded weights
    parameter [1:0] w1 = 2'b01;
    parameter [1:0] w2 = 2'b10;

    wire [3:0] weighted_sum;
    wire sigmoid_output;

    // Calculate weighted sum
    assign weighted_sum = (x1 * w1) + (x2 * w2);

    // Apply sigmoid function approximation: sigmoid(x) = 1 / (1 + e^(-x))
    // In our case, we will simply check if the weighted sum is greater than or equal to 3 (approximation for sigmoid > 0.5)
    // Output y = 1 if sigmoid_output > 0.5, else 0
    assign sigmoid_output = weighted_sum >= 3 ? 1 : 0;
    always @(*) begin
        y = sigmoid_output;
    end
endmodule