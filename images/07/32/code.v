module neural_net_backpropagation(
    input clk,
    input rst,
    input [7:0] input_data,
    input [7:0] target_output,
    input [7:0] initial_weight,
    input [7:0] learning_rate,
    output reg [7:0] updated_weight,
    output reg [7:0] output_data
);
    reg [7:0] error;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_weight <= initial_weight;
            output_data <= 8'b0;
        end else begin
            // Compute output
            output_data <= (input_data * updated_weight) >> 8; // Simple multiplication and right shift for scaling
            // Compute error
            error <= target_output - output_data;
            // Update weight
            updated_weight <= updated_weight + (error * learning_rate) >> 8; // Scale the update
        end
    end
endmodule