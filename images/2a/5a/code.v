module gradient_descent (
    input [15:0] current_value,
    input [15:0] learning_rate,
    output [15:0] next_value
);
    assign next_value = current_value - learning_rate; // since gradient is 1
endmodule