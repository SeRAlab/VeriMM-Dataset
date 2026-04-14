module linear_regression #(parameter N = 5) (  
    input [31:0] x0, y0,  
    input [31:0] x1, y1,  
    input [31:0] x2, y2,  
    input [31:0] x3, y3,  
    input [31:0] x4, y4,  
    output reg [31:0] m,  
    output reg [31:0] b  
);  
    wire [63:0] sum_x, sum_y, sum_xy, sum_x2;  
    reg [63:0] tmp_m, tmp_b;  
    integer i;  

    assign sum_x = x0 + x1 + x2 + x3 + x4;  
    assign sum_y = y0 + y1 + y2 + y3 + y4;  
    assign sum_xy = (x0*y0) + (x1*y1) + (x2*y2) + (x3*y3) + (x4*y4);  
    assign sum_x2 = (x0*x0) + (x1*x1) + (x2*x2) + (x3*x3) + (x4*x4);  

    always @(*) begin  
        tmp_m = (N * sum_xy - sum_x * sum_y) / (N * sum_x2 - sum_x * sum_x);  
        tmp_b = (sum_y - tmp_m * sum_x) / N;  
        m = tmp_m;  
        b = tmp_b;  
    end  
endmodule