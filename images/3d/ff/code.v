module backpropagation (
    input wire clk,
    input wire enable,
    input wire [3:0] weights, // 4-bit weights
    input wire [3:0] biases,   // 4-bit biases
    input wire [3:0] target,   // 4-bit target output
    output reg [3:0] updated_weights,
    output reg [3:0] updated_biases
);
    reg [3:0] output_layer; // Output of the network
    reg [3:0] error;        // Error calculation
    reg [3:0] learning_rate; // Simple constant learning rate

    initial begin
        learning_rate = 4'b0001; // Learning rate = 1
    end

    always @(posedge clk) begin
        if (enable) begin
            output_layer = weights + biases; // Simple linear combination
            error = target - output_layer; // Calculate error
            updated_weights = weights + (error * learning_rate); // Update weights
            updated_biases = biases + (error * learning_rate); // Update biases
        end
    end
endmodule