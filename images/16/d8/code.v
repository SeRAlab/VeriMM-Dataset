module gradient_descent (
    input clk,
    input rst,
    input [15:0] current_position,
    input [15:0] learning_rate,
    output reg [15:0] updated_position
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_position <= 16'b0;
        end else begin
            updated_position <= current_position - (learning_rate >> 1); // Simple gradient step
        end
    end
endmodule