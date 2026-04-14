module linear_regression (
    input [15:0] x1, x2, x3, x4, x5,
    input [15:0] y1, y2, y3, y4, y5,
    output reg [15:0] m,
    output reg [15:0] b
);
    reg [31:0] sum_x, sum_y, sum_xy, sum_xx;
    integer i;

    always @* begin
        sum_x = 0;
        sum_y = 0;
        sum_xy = 0;
        sum_xx = 0;

        // Calculating sums
        sum_x = x1 + x2 + x3 + x4 + x5;
        sum_y = y1 + y2 + y3 + y4 + y5;
        sum_xy = (x1 * y1) + (x2 * y2) + (x3 * y3) + (x4 * y4) + (x5 * y5);
        sum_xx = (x1 * x1) + (x2 * x2) + (x3 * x3) + (x4 * x4) + (x5 * x5);

        // Calculating slope (m) and y-intercept (b)
        m = (sum_xy - (sum_x * sum_y / 5)) / (sum_xx - (sum_x * sum_x / 5));
        b = (sum_y / 5) - (m * (sum_x / 5));
    end
endmodule