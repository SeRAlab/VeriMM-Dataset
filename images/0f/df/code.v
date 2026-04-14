module linear_regression (
    input [31:0] x0, x1, x2, x3, x4,
    input [31:0] y0, y1, y2, y3, y4,
    output reg [31:0] slope,
    output reg [31:0] intercept
);
    wire signed [63:0] sum_x, sum_y, sum_xy, sum_xx;
    wire signed [63:0] n;
    wire signed [63:0] m, b;

    assign n = 5;
    assign sum_x = x0 + x1 + x2 + x3 + x4;
    assign sum_y = y0 + y1 + y2 + y3 + y4;
    assign sum_xy = (x0 * y0) + (x1 * y1) + (x2 * y2) + (x3 * y3) + (x4 * y4);
    assign sum_xx = (x0 * x0) + (x1 * x1) + (x2 * x2) + (x3 * x3) + (x4 * x4);

    always @(*) begin
        // slope (m) calculation: m = (n*sum_xy - sum_x*sum_y) / (n*sum_xx - sum_x*sum_x)
        slope = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x * sum_x);
        // intercept (b) calculation: b = (sum_y - slope*sum_x) / n
        intercept = (sum_y - slope * sum_x) / n;
    end
endmodule