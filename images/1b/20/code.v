module gradient_descent(
    input [15:0] x,
    input [15:0] y,
    output reg [15:0] x_next,
    output reg [15:0] y_next
);
    // Fixed learning rate
    parameter LEARNING_RATE = 16'd10; // 0.1 in fixed point

    always @(*) begin
        // Gradient of f(x, y) = x^2 + y^2 is (2x, 2y)
        x_next = x - (LEARNING_RATE * x[15:0] >> 4); // 2x * 0.1
        y_next = y - (LEARNING_RATE * y[15:0] >> 4); // 2y * 0.1
    end
endmodule