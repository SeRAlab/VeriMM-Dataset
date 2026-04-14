module backpropagation (
    input [7:0] weights,          // Current weights
    input [7:0] inputs,           // Input features
    input [7:0] target,           // Expected output
    input [7:0] learning_rate,    // Learning rate
    output reg [7:0] new_weights   // Updated weights
);
    reg [7:0] output_neuron;
    reg [7:0] error;
    
    always @(weights, inputs, target, learning_rate) begin
        // Calculate output of the neuron (simple linear output)
        output_neuron = weights * inputs;

        // Compute error
        error = target - output_neuron;

        // Update weights using the backpropagation formula
        new_weights = weights + (learning_rate * error * inputs);
    end
endmodule