module gradient_descent (
    input wire clk,
    input wire reset,
    input wire [15:0] old_weight,
    input wire [15:0] learning_rate,
    input wire [15:0] gradient,
    output reg [15:0] new_weight
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        new_weight <= 16'b0;
    end else begin
        new_weight <= old_weight - (learning_rate * gradient);
    end
end

endmodule