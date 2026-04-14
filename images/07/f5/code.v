module gradient_descent (
    input wire clk,
    input wire rst,
    input wire [15:0] current_parameter,
    input wire [15:0] learning_rate,
    input wire [15:0] gradient,
    output reg [15:0] new_parameter
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            new_parameter <= 16'b0;
        end else begin
            new_parameter <= current_parameter - (learning_rate * gradient);
        end
    end
endmodule