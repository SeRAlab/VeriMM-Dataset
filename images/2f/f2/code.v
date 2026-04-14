module gradient_descent (
    input [15:0] params, // current parameters
    input [15:0] gradient, // computed gradient
    input [15:0] learning_rate, // learning rate
    output [15:0] updated_params // updated parameters
);
    assign updated_params = params - (gradient * learning_rate);
endmodule