module simple_nn_layer (
    input clk,
    input reset,
    input [4:0] inputs,
    input [4:0] weights,
    input [4:0] error_gradient,
    input [4:0] learning_rate,
    output reg [4:0] outputs,
    output reg [4:0] updated_weights
);
    reg [4:0] weighted_sum;
    reg [4:0] new_weights;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            outputs <= 5'b0;
            updated_weights <= 5'b0;
        end else begin
            // Compute weighted sum
            weighted_sum <= inputs * weights;
            outputs <= weighted_sum;

            // Update weights with backpropagation
            new_weights <= weights - (error_gradient * learning_rate);
            updated_weights <= new_weights;
        end
    end
endmodule