module linear_regression (
    input [15:0] x0, y0,
    input [15:0] x1, y1,
    input [15:0] x2, y2,
    input [15:0] x3, y3,
    input [15:0] x4, y4,
    output reg [15:0] slope,
    output reg [15:0] intercept
);
    wire signed [31:0] sum_x, sum_y, sum_xy, sum_x2;
    wire signed [31:0] N = 5; // number of points

    assign sum_x = x0 + x1 + x2 + x3 + x4;
    assign sum_y = y0 + y1 + y2 + y3 + y4;
    assign sum_xy = x0*y0 + x1*y1 + x2*y2 + x3*y3 + x4*y4;
    assign sum_x2 = x0*x0 + x1*x1 + x2*x2 + x3*x3 + x4*x4;

    always @(*) begin
        // slope = (N * sum_xy - sum_x * sum_y) / (N * sum_x2 - sum_x * sum_x)
        slope = (N * sum_xy - sum_x * sum_y) / (N * sum_x2 - sum_x * sum_x);

        // intercept = (sum_y - slope * sum_x) / N
        intercept = (sum_y - slope * sum_x) / N;
    end
endmodule