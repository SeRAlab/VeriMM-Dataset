module neural_network_layer (
    input [7:0] inputs,         // 8-bit input vector
    input [7:0] target_output,  // 8-bit target output
    input [7:0] current_weights, // 8-bit weights
    input clk,                  // clock signal
    input rst,                  // reset signal
    output reg [7:0] updated_weights // updated weights after backpropagation
);
    reg [7:0] output_value;
    reg [7:0] error;
    reg [7:0] learning_rate;
    
    initial begin
        learning_rate = 8'd5; // Fixed learning rate
        updated_weights = 8'b0; // Initialize updated weights
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_weights <= 8'b0; // Reset weights on reset
        end else begin
            output_value <= inputs * current_weights; // Compute output
            error <= target_output - output_value; // Compute error
            updated_weights <= current_weights + (error * learning_rate); // Update weights
        end
    end
endmodule