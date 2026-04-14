module gradient_descent (
    input wire clk,
    input wire rst,
    input wire [31:0] current_value, // Current parameter value
    input wire [31:0] learning_rate,  // Learning rate
    output reg [31:0] updated_value    // Updated parameter value
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_value <= 32'd0; // Reset output
        end else begin
            // Gradient of the function (e.g., f(x) = (x-5)^2 is 2*(x-5))
            // Minimize function: f(x) = x^2 - 10x + 25, gradient = 2*(x - 5)
            // Updated value = current_value - learning_rate * (2 * (current_value - 5))
            updated_value <= current_value - learning_rate * (current_value - 5) * 2;
        end
    end
endmodule