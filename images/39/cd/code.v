module neural_network (
    input clk,
    input rst,
    input [3:0] features,
    input [1:0] target,
    output reg [1:0] output_class
);
    reg [3:0] weights [1:0]; // Two weights for each output class
    reg [4:0] learning_rate; // Learning rate
    reg [3:0] weighted_sum;

    initial begin
        weights[0] = 4'b0001; // Initial weights for class 0
        weights[1] = 4'b0001; // Initial weights for class 1
        learning_rate = 5'd1; // Set learning rate to 1
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_class <= 2'b00;
        end else begin
            // Forward pass
            weighted_sum = features * weights[0]; // Only for class 0 for simplicity
            if (weighted_sum > 4'b0100) begin // Threshold for class 0
                output_class <= 2'b00;
            end else begin
                output_class <= 2'b01;
            end

            // Backward pass
            if (output_class != target) begin
                // Update weights for the target class
                weights[target] <= weights[target] + (features * learning_rate);
            end
        end
    end
endmodule