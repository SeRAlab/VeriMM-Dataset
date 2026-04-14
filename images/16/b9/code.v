module gradient_descent (
    input [15:0] current_parameters,
    input [15:0] gradient,
    input [7:0] learning_rate,
    output reg [15:0] new_parameters
);
    always @(*) begin
        new_parameters = current_parameters - (learning_rate * gradient) >> 8; // Right shift to adjust for fixed point representation
    end
endmodule