module gradient_descent (
    input [15:0] current_value,
    input [15:0] learning_rate,
    input [15:0] gradient,
    output [15:0] updated_value
);
    assign updated_value = current_value - (learning_rate * gradient);
endmodule