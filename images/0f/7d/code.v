module backpropagation(
    input clk,
    input rst,
    input [7:0] weight_in,
    input [7:0] bias_in,
    input [7:0] gradient_in,
    input [7:0] learning_rate,
    output reg [7:0] weight_out,
    output reg [7:0] bias_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            weight_out <= 8'b0;
            bias_out <= 8'b0;
        end else begin
            // Update weights and biases using gradient descent
            weight_out <= weight_in - (gradient_in * learning_rate);
            bias_out <= bias_in - (gradient_in * learning_rate);
        end
    end
endmodule