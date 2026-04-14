module gradient_descent (
    input [3:0] x_current,
    output [3:0] x_next
);
    // Gradient of f(x) = (x - 3)^2 is 2*(x - 3)
    wire signed [3:0] gradient;
    assign gradient = 2 * (x_current - 4'b0011); // 4'b0011 is 3 in binary

    // Update x: x_next = x_current - learning_rate * gradient
    assign x_next = x_current - gradient;

endmodule