module linear_regression(
    input [31:0] x1, x2, x3, x4, x5,
    input [31:0] y1, y2, y3, y4, y5,
    output reg [31:0] slope,
    output reg [31:0] intercept
);
    reg [31:0] sum_x, sum_y, sum_xy, sum_xx;
    integer i;

    always @(*) begin
        sum_x = x1 + x2 + x3 + x4 + x5;
        sum_y = y1 + y2 + y3 + y4 + y5;
        sum_xy = (x1 * y1) + (x2 * y2) + (x3 * y3) + (x4 * y4) + (x5 * y5);
        sum_xx = (x1 * x1) + (x2 * x2) + (x3 * x3) + (x4 * x4) + (x5 * x5);
        
        slope = (sum_xy - (sum_x * sum_y) / 5) / (sum_xx - (sum_x * sum_x) / 5);
        intercept = (sum_y - slope * sum_x / 5) / 5;
    end
endmodule