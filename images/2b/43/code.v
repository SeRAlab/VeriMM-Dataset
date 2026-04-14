module backpropagation(
    input [15:0] weights,       // Weights of the neural network
    input [15:0] learning_rate, // Learning rate
    input [15:0] input_data,    // Input data
    input [15:0] target_output,  // Target output
    output reg [15:0] updated_weights // Updated weights
);
    reg [15:0] error;
    always @(weights, input_data, target_output) begin
        // Calculate the error
        error = target_output - (weights * input_data);
        // Update weights: w_new = w_old + learning_rate * error * input
        updated_weights = weights + (learning_rate * error * input_data);
    end
endmodule