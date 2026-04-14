module GradientDescent (
    input clk,
    input reset,
    input signed [15:0] current_weight,
    input signed [15:0] error,
    input signed [15:0] learning_rate,
    output reg signed [15:0] updated_weight
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            updated_weight <= 16'd0;
        end else begin
            updated_weight <= current_weight - (error * learning_rate);
        end
    end
endmodule