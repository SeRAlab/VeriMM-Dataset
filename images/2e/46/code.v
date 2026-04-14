module GradientDescent (
    input clk,
    input reset,
    input [15:0] current_value,
    input [15:0] learning_rate,
    input [15:0] gradient,
    output reg [15:0] updated_value
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        updated_value <= 16'b0;
    end else begin
        updated_value <= current_value - (learning_rate * gradient);
    end
end

endmodule