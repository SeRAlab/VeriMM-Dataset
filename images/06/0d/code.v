module linear_regression (
    input [7:0] x0, y0,
    input [7:0] x1, y1,
    input [7:0] x2, y2,
    input [7:0] x3, y3,
    input [7:0] x4, y4,
    output reg signed [15:0] slope,
    output reg signed [15:0] intercept
);
    integer i;
    integer sum_x, sum_y, sum_xx, sum_xy;
    
    always @(*) begin
        sum_x = x0 + x1 + x2 + x3 + x4;
        sum_y = y0 + y1 + y2 + y3 + y4;
        sum_xx = (x0*x0) + (x1*x1) + (x2*x2) + (x3*x3) + (x4*x4);
        sum_xy = (x0*y0) + (x1*y1) + (x2*y2) + (x3*y3) + (x4*y4);
        
        // Calculate slope = (N*sum_xy - sum_x*sum_y) / (N*sum_xx - sum_x*sum_x)
        // Calculate intercept = (sum_y - slope * sum_x) / N
        
        slope = (5 * sum_xy - sum_x * sum_y) / (5 * sum_xx - sum_x * sum_x);
        intercept = (sum_y - slope * sum_x) / 5;
    end
endmodule