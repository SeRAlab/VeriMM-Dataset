module gradient_descent (
    input signed [15:0] current_position,
    input signed [15:0] gradient,
    input signed [15:0] learning_rate,
    output signed [15:0] new_position
);
    wire signed [31:0] product; // To hold the multiplication result
    assign product = learning_rate * gradient; // Compute learning_rate * gradient
    assign new_position = current_position - product[15:0]; // Update position
endmodule