module GradientDescentOptimizer (
    input clk,
    input [15:0] current_weight,
    input [15:0] gradient,
    input [15:0] learning_rate,
    output reg [15:0] updated_weight
);
    always @(posedge clk) begin
        updated_weight <= current_weight - (gradient * learning_rate);
    end
endmodule