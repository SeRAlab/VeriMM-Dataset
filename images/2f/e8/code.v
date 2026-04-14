module gradient_descent (
    input wire clk,
    input wire rst,
    input wire [15:0] current_value,
    input wire [15:0] gradient_value,
    output reg [15:0] new_value
);
    parameter LEARNING_RATE = 16'd1; // Fixed learning rate

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            new_value <= 16'd0;
        end else begin
            new_value <= current_value - (LEARNING_RATE * gradient_value);
        end
    end
endmodule