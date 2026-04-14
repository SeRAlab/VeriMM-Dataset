module linear_regression (  
    input [15:0] x,  
    input [15:0] y,  
    output reg [15:0] m,  
    output reg [15:0] b  
);  
    reg [31:0] sum_x, sum_y, sum_xy, sum_xx;  
    reg [15:0] n;  
    
    always @* begin  
        // For simplicity, we will assume n is fixed to 5 (for 5 points).  
        n = 5;  
        sum_x = 0;  
        sum_y = 0;  
        sum_xy = 0;  
        sum_xx = 0;  
        
        // Sample data points (x,y) { (1,2), (2,3), (3,5), (4,4), (5,5) }  
        sum_x = sum_x + (x == 1 ? 1 : (x == 2 ? 2 : (x == 3 ? 3 : (x == 4 ? 4 : (x == 5 ? 5 : 0)))));  
        sum_y = sum_y + (y == 2 ? 2 : (y == 3 ? 3 : (y == 5 ? 5 : (y == 4 ? 4 : (y == 5 ? 5 : 0)))));  
        sum_xy = sum_xy + (x * y);  
        sum_xx = sum_xx + (x * x);  
        
        // Calculate slope (m) and intercept (b) using least squares method  
        m = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x * sum_x);  
        b = (sum_y - m * sum_x) / n;  
    end  
endmodule