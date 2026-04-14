module neural_layer (
    input clk,
    input rst,
    input [3:0] inputs,
    input [3:0] target_outputs,
    output reg [3:0] adjusted_weights
);
    reg [3:0] weights [0:3]; // Fixed weights
    reg [3:0] gradients;
    reg [3:0] error;

    initial begin
        weights[0] = 4'b0001; // Example weights
        weights[1] = 4'b0010;
        weights[2] = 4'b0100;
        weights[3] = 4'b1000;
        adjusted_weights = 4'b0000;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            adjusted_weights <= 4'b0000;
        end else begin
            error = target_outputs - inputs; // Compute error
            gradients = error; // For simplicity, gradients are equal to error
            // Adjust weights with a simple learning rate
            adjusted_weights[0] <= weights[0] + (gradients[0] >> 1);
            adjusted_weights[1] <= weights[1] + (gradients[1] >> 1);
            adjusted_weights[2] <= weights[2] + (gradients[2] >> 1);
            adjusted_weights[3] <= weights[3] + (gradients[3] >> 1);
        end
    end
endmodule