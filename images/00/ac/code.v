module linear_regression(input [15:0] x0, input [15:0] y0,  
                        input [15:0] x1, input [15:0] y1,  
                        input [15:0] x2, input [15:0] y2,  
                        input [15:0] x3, input [15:0] y3,  
                        input [15:0] x4, input [15:0] y4,  
                        output reg [15:0] m, output reg [15:0] b);  

    reg [31:0] sum_x, sum_y, sum_xy, sum_x2;  
    reg [31:0] n;  

    always @(*) begin  
        sum_x = x0 + x1 + x2 + x3 + x4;  
        sum_y = y0 + y1 + y2 + y3 + y4;  
        sum_xy = (x0 * y0) + (x1 * y1) + (x2 * y2) + (x3 * y3) + (x4 * y4);  
        sum_x2 = (x0 * x0) + (x1 * x1) + (x2 * x2) + (x3 * x3) + (x4 * x4);  
        n = 5;  

        m = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x * sum_x);  
        b = (sum_y - m * sum_x) / n;  
    end  
endmodule