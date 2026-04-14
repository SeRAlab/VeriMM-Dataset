module gradient_descent (
    input clk,
    input [15:0] current_value, // Assume fixed-point representation
    input [15:0] learning_rate, // Fixed-point representation
    input [15:0] gradient,       // Fixed-point representation
    output reg [15:0] new_value  // Updated value after gradient descent
);
    always @(posedge clk) begin
        new_value <= current_value - (learning_rate * gradient);
    end
endmodule