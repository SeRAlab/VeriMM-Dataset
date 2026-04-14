module neural_network_layer (
    input [7:0] x1, x2, x3,           // 3 input neurons
    input [7:0] target1, target2,     // Target outputs
    input [7:0] learning_rate,         // Learning rate
    input clk,                         // Clock signal
    output reg [7:0] out1, out2,       // Output neurons
    output reg [7:0] weight1_1, weight1_2, // Weights for output 1
    output reg [7:0] weight2_1, weight2_2  // Weights for output 2
);
    reg [7:0] weighted_input1, weighted_input2;
    reg [7:0] error1, error2;

    // Forward pass
    always @(posedge clk) begin
        weighted_input1 = (x1 * weight1_1) + (x2 * weight1_2) + (x3 * 1); // Bias as 1
        weighted_input2 = (x1 * weight2_1) + (x2 * weight2_2) + (x3 * 1); // Bias as 1
        out1 = weighted_input1;
        out2 = weighted_input2;

        // Backpropagation
        error1 = target1 - out1;
        error2 = target2 - out2;

        // Update weights
        weight1_1 = weight1_1 + (learning_rate * error1 * x1);
        weight1_2 = weight1_2 + (learning_rate * error1 * x2);
        weight2_1 = weight2_1 + (learning_rate * error2 * x1);
        weight2_2 = weight2_2 + (learning_rate * error2 * x2);
    end
endmodule