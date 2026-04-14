module gradient_descent(
    input [15:0] current_weights, // 16-bit input for current weights
    input [15:0] gradient, // 16-bit input for gradient
    input [15:0] learning_rate, // 16-bit input for learning rate
    output reg [15:0] updated_weights // 16-bit output for updated weights
);
    always @(*) begin
        updated_weights = current_weights - (gradient * learning_rate);
    end
endmodule