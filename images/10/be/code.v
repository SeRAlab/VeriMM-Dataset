module linear_regression (
    input [15:0] x0, y0, // First data point
    input [15:0] x1, y1, // Second data point
    input [15:0] x2, y2, // Third data point
    input [15:0] x3, y3, // Fourth data point
    input [15:0] x4, y4, // Fifth data point
    output reg [15:0] slope, // Output slope
    output reg [15:0] intercept // Output y-intercept
);
    wire signed [31:0] sum_x, sum_y, sum_xy, sum_x2;
    wire signed [15:0] n;

    assign sum_x = x0 + x1 + x2 + x3 + x4;
    assign sum_y = y0 + y1 + y2 + y3 + y4;
    assign sum_xy = (x0*y0) + (x1*y1) + (x2*y2) + (x3*y3) + (x4*y4);
    assign sum_x2 = (x0*x0) + (x1*x1) + (x2*x2) + (x3*x3) + (x4*x4);
    assign n = 5; // Number of data points

    always @(*) begin
        // Calculate slope (m) = (n*Σxy - Σx*Σy) / (n*Σx^2 - (Σx)^2)
        slope = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x * sum_x);
        // Calculate intercept (b) = (Σy - slope*Σx) / n
        intercept = (sum_y - slope * sum_x) / n;
    end
endmodule