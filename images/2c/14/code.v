module linear_regression (
    input [15:0] x1, x2, x3, x4, x5,
    input [15:0] y1, y2, y3, y4, y5,
    output reg signed [31:0] m, // slope
    output reg signed [31:0] b  // intercept
);
    integer i;
    reg signed [31:0] sum_x, sum_y, sum_xy, sum_x2;
    reg signed [31:0] n;

    always @(*) begin
        sum_x = 0;
        sum_y = 0;
        sum_xy = 0;
        sum_x2 = 0;
        n = 5; // number of points

        // Summing the values
        sum_x = x1 + x2 + x3 + x4 + x5;
        sum_y = y1 + y2 + y3 + y4 + y5;
        sum_xy = (x1 * y1) + (x2 * y2) + (x3 * y3) + (x4 * y4) + (x5 * y5);
        sum_x2 = (x1 * x1) + (x2 * x2) + (x3 * x3) + (x4 * x4) + (x5 * x5);

        // Calculate slope (m) and intercept (b)
        m = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x * sum_x);
        b = (sum_y - m * sum_x) / n;
    end
endmodule