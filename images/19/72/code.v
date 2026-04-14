module neural_network_layer (
    input clk,
    input rst,
    input [4:0] input_vector,
    input [4:0] weights,
    input [4:0] target_output,
    output reg [4:0] output_vector,
    output reg [4:0] adjusted_weights
);
    reg [4:0] error;
    parameter LEARNING_RATE = 5'b00001; // Learning rate for weight adjustment

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_vector <= 5'b00000;
            adjusted_weights <= 5'b00000;
        end else begin
            // Calculate output
            output_vector <= input_vector * weights;

            // Calculate error
            error <= target_output - output_vector;

            // Adjust weights based on error
            adjusted_weights <= weights + (error * LEARNING_RATE);
        end
    end
endmodule