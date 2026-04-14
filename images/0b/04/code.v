module linear_regression (
    input [15:0] x0, x1, x2, x3, x4,  // Input feature vector
    input [15:0] y0, y1, y2, y3, y4,  // Input target vector
    output [15:0] slope,               // Output slope of the regression line
    output [15:0] intercept             // Output intercept of the regression line
);
    wire [31:0] n;                     // Number of points
    wire [31:0] sum_x, sum_y;          // Sum of X and Y
    wire [31:0] sum_xy, sum_x2;        // Sum of XY and X^2

    assign n = 5;                       // Number of points
    assign sum_x = x0 + x1 + x2 + x3 + x4;
    assign sum_y = y0 + y1 + y2 + y3 + y4;
    assign sum_xy = x0*y0 + x1*y1 + x2*y2 + x3*y3 + x4*y4;
    assign sum_x2 = x0*x0 + x1*x1 + x2*x2 + x3*x3 + x4*x4;

    assign slope = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x * sum_x);
    assign intercept = (sum_y - slope * sum_x) / n;

endmodule