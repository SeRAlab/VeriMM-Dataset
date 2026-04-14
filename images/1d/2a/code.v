module gradient_descent(
    input clk,
    input rst,
    input [31:0] current_value,
    input [31:0] learning_rate,
    output reg [31:0] new_value
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            new_value <= 32'b0;
        end else begin
            new_value <= current_value - learning_rate; // Assuming gradient = 1
        end
    end
endmodule