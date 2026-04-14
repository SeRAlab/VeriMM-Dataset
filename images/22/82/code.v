module backpropagation (
    input clk,
    input rst,
    input [0:0] learn_rate,
    input [24:0] input_vector, // 5 bits for each of the 5 elements
    input [24:0] target_vector, // 5 bits for each of the 5 elements
    output reg [24:0] weights // 5 bits for each of the 5 elements
);
    reg [24:0] actual_output; // 5 bits for each of the 5 elements
    reg [24:0] errors; // 5 bits for each of the 5 elements
    reg [24:0] weight_updates; // 5 bits for each of the 5 elements

    // Initialize weights
    initial begin
        weights = 25'b0000000000000000000000000; // Initial weights
    end

    // Sigmoid activation function
    function [24:0] sigmoid;
        input [24:0] x;
        begin
            sigmoid = x / (1 + x); // Simplified sigmoid for demonstration
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            weights <= 25'b0000000000000000000000000; // Reset weights
        end else begin
            // Compute actual output
            actual_output = sigmoid(input_vector * weights);

            // Compute errors
            errors = target_vector - actual_output;

            // Compute weight updates
            weight_updates = learn_rate * errors * input_vector;

            // Update weights
            weights <= weights + weight_updates;
        end
    end
endmodule