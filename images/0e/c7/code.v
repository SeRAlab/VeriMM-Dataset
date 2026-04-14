module neural_network #(parameter INPUTS=3, parameter OUTPUTS=2) (
    input wire clk,
    input wire reset,
    input wire [INPUTS-1:0] inputs,
    input wire [OUTPUTS-1:0] expected_outputs,
    output reg [OUTPUTS-1:0] outputs
);
    reg [INPUTS-1:0] weights [OUTPUTS-1:0];
    reg [OUTPUTS-1:0] biases;
    reg [OUTPUTS-1:0] deltas;

    integer i, j;
    parameter LEARNING_RATE = 8'b00000001; // Example fixed learning rate

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize weights and biases
            for (i = 0; i < OUTPUTS; i = i + 1) begin
                biases[i] <= 0;
                for (j = 0; j < INPUTS; j = j + 1) begin
                    weights[i][j] <= 0;
                end
            end
            outputs <= 0;
        end else begin
            // Forward pass
            for (i = 0; i < OUTPUTS; i = i + 1) begin
                outputs[i] <= biases[i];
                for (j = 0; j < INPUTS; j = j + 1) begin
                    outputs[i] <= outputs[i] + (weights[i][j] * inputs[j]);
                end
                // Apply activation (simple ReLU for demonstration)
                if (outputs[i] < 0) outputs[i] <= 0;
            end

            // Backward pass
            for (i = 0; i < OUTPUTS; i = i + 1) begin
                deltas[i] <= (expected_outputs[i] - outputs[i]); // Calculate error
                biases[i] <= biases[i] + (LEARNING_RATE * deltas[i]);
                for (j = 0; j < INPUTS; j = j + 1) begin
                    weights[i][j] <= weights[i][j] + (LEARNING_RATE * deltas[i] * inputs[j]);
                end
            end
        end
    end
endmodule