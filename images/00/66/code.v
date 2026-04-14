module gradient_descent (
    input clk,
    input rst,
    input signed [3:0] gradient_x,
    input signed [3:0] gradient_y,
    output reg signed [3:0] position_x,
    output reg signed [3:0] position_y
);
    parameter signed [3:0] learning_rate = 4'h1; // Representing 0.1 as Q4 format

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            position_x <= 4'b0000;
            position_y <= 4'b0000;
        end else begin
            position_x <= position_x - (gradient_x >>> 1) * learning_rate; // Update position with gradient
            position_y <= position_y - (gradient_y >>> 1) * learning_rate; // Update position with gradient
        end
    end
endmodule