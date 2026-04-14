module neural_network_layer(
    input wire clk,
    input wire rst,
    input wire [7:0] input_data, // 8-bit input data for the neuron
    input wire [7:0] weights, // 8-bit weights
    input wire [7:0] bias, // 8-bit bias
    input wire [7:0] target, // target output
    input wire train, // signal to indicate training mode
    output reg [7:0] output_data, // output of the neuron
    output reg [7:0] updated_weights, // updated weights after training
    output reg [7:0] updated_bias // updated bias after training
);
    reg [15:0] net_input; // 16-bit net input to prevent overflow
    reg [15:0] error;
    reg [15:0] learning_rate = 8'h01; // fixed learning rate for simplicity

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_data <= 8'b0;
            updated_weights <= weights;
            updated_bias <= bias;
        end else begin
            // Forward pass
            net_input = (input_data * weights) + bias;
            output_data <= net_input[7:0]; // Assuming activation is linear for simplicity
            
            if (train) begin
                // Backward pass
                error = target - output_data; // Calculate error
                updated_weights <= weights + (error * input_data) / learning_rate; // Update weights
                updated_bias <= bias + (error) / learning_rate; // Update bias
            end
        end
    end
endmodule