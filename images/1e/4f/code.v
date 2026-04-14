module backpropagation(
    input [7:0] input_data,
    input [7:0] weights_hidden,
    input [7:0] bias_hidden,
    input [7:0] expected_output,
    input [7:0] learning_rate,
    output reg [7:0] new_weights_hidden,
    output reg [7:0] new_bias_hidden
);
    reg [7:0] output_hidden;
    reg [7:0] error;
    
    always @(input_data, weights_hidden, bias_hidden, expected_output, learning_rate) begin
        // Compute the output of the hidden layer
        output_hidden = (input_data * weights_hidden + bias_hidden) > 128 ? 1 : 0; // Binary step
        
        // Compute the error
        error = expected_output - output_hidden;
        
        // Adjust the weights and biases
        new_weights_hidden = weights_hidden + (error * input_data * learning_rate) >> 8; // Scale learning
        new_bias_hidden = bias_hidden + (error * learning_rate) >> 8; // Scale learning
    end
endmodule