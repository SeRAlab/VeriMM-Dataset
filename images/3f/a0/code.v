module GradientDescent (
    input wire clk,
    input wire rst,
    input wire [31:0] current_value,
    input wire [31:0] learning_rate,
    input wire [31:0] gradient,
    output reg [31:0] updated_value
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_value <= 32'b0;
        end else begin
            updated_value <= current_value - (learning_rate * gradient);
        end
    end
endmodule