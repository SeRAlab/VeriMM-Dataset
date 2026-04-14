module linear_regression (
    input [15:0] x1, x2, x3, x4, x5,
    input [15:0] y1, y2, y3, y4, y5,
    output reg [15:0] slope,
    output reg [15:0] intercept
);
    wire signed [31:0] sum_x, sum_y, sum_xx, sum_xy;
    wire signed [31:0] n;

    assign n = 5;
    assign sum_x = x1 + x2 + x3 + x4 + x5;
    assign sum_y = y1 + y2 + y3 + y4 + y5;
    assign sum_xx = (x1*x1) + (x2*x2) + (x3*x3) + (x4*x4) + (x5*x5);
    assign sum_xy = (x1*y1) + (x2*y2) + (x3*y3) + (x4*y4) + (x5*y5);

    always @(*) begin
        slope = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x * sum_x);
        intercept = (sum_y - slope * sum_x) / n;
    end
endmodule