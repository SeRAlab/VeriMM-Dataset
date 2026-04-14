module gradient_descent (
    input wire clk,
    input wire rst,
    input wire [15:0] current_value,
    input wire [15:0] gradient,
    input wire [15:0] learning_rate,
    output reg [15:0] new_value
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            new_value <= 16'b0;
        end else begin
            new_value <= current_value - (learning_rate * gradient) >> 8; // Simple fixed-point division by 256
        end
    end
endmodule