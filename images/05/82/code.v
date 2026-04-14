module backpropagation(
    input clk,
    input rst,
    input [7:0] input_vector,  // 8-bit input vector
    input [7:0] expected_output, // 8-bit expected output
    output reg [7:0] weights,   // 8-bit weights
    output reg [7:0] bias       // 8-bit bias
);
    reg [15:0] weighted_sum; // 16-bit for weighted sum
    reg [7:0] output_signal;
    reg [7:0] error;

    // Sigmoid function approximation
    function [7:0] sigmoid;
        input [15:0] x;
        begin
            sigmoid = (x < 16'd0) ? 8'd0 : (x > 16'd255) ? 8'd255 : (x[7:0] * 8'd255) / (x[7:0] + 8'd1);
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            weights <= 8'd0;
            bias <= 8'd0;
        end else begin
            weighted_sum = (input_vector * weights) + bias;
            output_signal = sigmoid(weighted_sum);
            error = expected_output - output_signal;
            weights <= weights + (error * input_vector) >> 8; // Adjust weights
            bias <= bias + (error >> 1); // Adjust bias
        end
    end
endmodule