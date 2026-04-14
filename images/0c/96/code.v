module gradient_descent (
    input clk,
    input rst,
    input signed [15:0] current_position,
    input signed [15:0] learning_rate,
    input signed [15:0] error_gradient,
    output reg signed [15:0] updated_position
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        updated_position <= 16'h0000;
    end else begin
        updated_position <= current_position - (learning_rate * error_gradient);
    end
end

endmodule