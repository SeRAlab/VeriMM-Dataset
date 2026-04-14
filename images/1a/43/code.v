module linear_regression (
    input [31:0] x0, y0,
    input [31:0] x1, y1,
    input [31:0] x2, y2,
    input [31:0] x3, y3,
    input [31:0] x4, y4,
    output reg signed [31:0] m,
    output reg signed [31:0] b
);
    integer N;
    integer sum_x, sum_y, sum_xy, sum_x2;
    
    always @(*) begin
        N = 5;
        sum_x = x0 + x1 + x2 + x3 + x4;
        sum_y = y0 + y1 + y2 + y3 + y4;
        sum_xy = (x0 * y0) + (x1 * y1) + (x2 * y2) + (x3 * y3) + (x4 * y4);
        sum_x2 = (x0 * x0) + (x1 * x1) + (x2 * x2) + (x3 * x3) + (x4 * x4);

        // Calculate slope (m)
        m = (N * sum_xy - sum_x * sum_y) / (N * sum_x2 - sum_x * sum_x);
        // Calculate intercept (b)
        b = (sum_y - m * sum_x) / N;
    end
endmodule