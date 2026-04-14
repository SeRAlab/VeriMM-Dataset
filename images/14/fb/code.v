module linear_regression(
    input [15:0] x0, x1, x2, x3, x4, // x values
    input [15:0] y0, y1, y2, y3, y4, // y values
    output reg [15:0] m, // slope
    output reg [15:0] b  // y-intercept
);
    
    reg signed [31:0] sum_x, sum_y, sum_xy, sum_x2;
    integer i;

    always @* begin
        sum_x = 0;
        sum_y = 0;
        sum_xy = 0;
        sum_x2 = 0;
        
        // Calculate sums
        for (i = 0; i < 5; i = i + 1) begin
            case(i)
                0: begin sum_x = sum_x + x0; sum_y = sum_y + y0; sum_xy = sum_xy + x0 * y0; sum_x2 = sum_x2 + x0 * x0; end
                1: begin sum_x = sum_x + x1; sum_y = sum_y + y1; sum_xy = sum_xy + x1 * y1; sum_x2 = sum_x2 + x1 * x1; end
                2: begin sum_x = sum_x + x2; sum_y = sum_y + y2; sum_xy = sum_xy + x2 * y2; sum_x2 = sum_x2 + x2 * x2; end
                3: begin sum_x = sum_x + x3; sum_y = sum_y + y3; sum_xy = sum_xy + x3 * y3; sum_x2 = sum_x2 + x3 * x3; end
                4: begin sum_x = sum_x + x4; sum_y = sum_y + y4; sum_xy = sum_xy + x4 * y4; sum_x2 = sum_x2 + x4 * x4; end
            endcase
        end

        // Calculate slope (m) and y-intercept (b)
        m = ((5 * sum_xy) - (sum_x * sum_y)) / (5 * sum_x2 - (sum_x * sum_x));
        b = (sum_y - m * sum_x) / 5;
    end
endmodule