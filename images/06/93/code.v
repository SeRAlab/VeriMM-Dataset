module gradient_descent (
    input clk,
    input [15:0] current_value,
    input [15:0] learning_rate,
    input [15:0] gradient,
    output reg [15:0] updated_value
);

always @(posedge clk) begin
    updated_value <= current_value - (learning_rate * gradient);
end

endmodule