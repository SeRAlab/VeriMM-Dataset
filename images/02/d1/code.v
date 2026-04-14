module GradientDescent (
    input clk,
    input rst,
    input [15:0] x_in,
    input [15:0] learning_rate,
    input [15:0] gradient,
    output reg [15:0] x_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_out <= 16'h0000; // Reset x_out to 0
        end else begin
            x_out <= x_in - (learning_rate * gradient >> 8); // Update x
        end
    end
endmodule