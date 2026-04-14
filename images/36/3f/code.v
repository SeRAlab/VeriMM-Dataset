module gradient_descent (
    input clk,
    input reset,
    input [15:0] current_position,
    input [15:0] learning_rate,
    output reg [15:0] new_position
);
    parameter integer GRADIENT = 16'h0001; // Constant gradient value

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            new_position <= 16'h0000; // Reset position
        end else begin
            new_position <= current_position - (learning_rate * GRADIENT);
        end
    end
endmodule