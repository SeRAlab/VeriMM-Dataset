module neural_network_layer(
    input signed [3:0] X1,
    input signed [3:0] X2,
    input signed [3:0] X3,
    input signed [3:0] W1,
    input signed [3:0] W2,
    input signed [3:0] W3,
    input signed [3:0] target,
    input clk,
    input rst,
    output reg signed [3:0] output_value,
    output reg signed [3:0] new_W1,
    output reg signed [3:0] new_W2,
    output reg signed [3:0] new_W3
);

    reg signed [3:0] learning_rate = 1; // Fixed learning rate
    reg signed [3:0] error;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_value <= 0;
            new_W1 <= W1;
            new_W2 <= W2;
            new_W3 <= W3;
        end else begin
            // Calculate the output of the neuron
            output_value <= (X1 * new_W1) + (X2 * new_W2) + (X3 * new_W3);

            // Calculate the error
            error <= target - output_value;

            // Update the weights
            new_W1 <= new_W1 + (learning_rate * error * X1);
            new_W2 <= new_W2 + (learning_rate * error * X2);
            new_W3 <= new_W3 + (learning_rate * error * X3);
        end
    end
endmodule