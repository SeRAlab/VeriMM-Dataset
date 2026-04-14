module gradient_descent (
    input clk,
    input rst,
    input [15:0] current_point, // Current parameters
    input [15:0] gradient,       // Gradient value
    input [15:0] learning_rate,  // Learning rate
    output reg [15:0] updated_point // Updated parameters
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_point <= 16'b0;
        end else begin
            updated_point <= current_point - (gradient * learning_rate);
        end
    end
endmodule