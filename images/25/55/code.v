module gradient_descent(
    input [15:0] x,
    input [15:0] y,
    input [15:0] dx,
    input [15:0] dy,
    input [15:0] learning_rate,
    output reg [15:0] x_new,
    output reg [15:0] y_new
);
    always @(*) begin
        x_new = x - (dx * learning_rate);
        y_new = y - (dy * learning_rate);
    end
endmodule