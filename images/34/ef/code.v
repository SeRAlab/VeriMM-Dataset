module GradientDescent (
    input clk,
    input reset,
    input [15:0] current_position,
    input [15:0] alpha,
    output reg [15:0] new_position
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            new_position <= 16'b0;
        end else begin
            new_position <= current_position - alpha; // Gradient is assumed to be 1
        end
    end
endmodule