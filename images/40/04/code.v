module iir_filter(clk, rst, x_in, y_out);  
    input clk;  
    input rst;  
    input signed [15:0] x_in;  
    output reg signed [15:0] y_out;  

    // Coefficients (example values, can be adjusted for actual filter design)  
    parameter signed [15:0] b0 = 16'sd1;  
    parameter signed [15:0] b1 = 16'sd2;  
    parameter signed [15:0] b2 = 16'sd3;  
    parameter signed [15:0] b3 = 16'sd4;  
    parameter signed [15:0] b4 = 16'sd5;  
    parameter signed [15:0] a1 = 16'sd1;  
    parameter signed [15:0] a2 = 16'sd2;  
    parameter signed [15:0] a3 = 16'sd3;  
    parameter signed [15:0] a4 = 16'sd4;  

    reg signed [15:0] x[0:4];  
    reg signed [15:0] y[0:4];  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y_out <= 16'sd0;  
            x[0] <= 16'sd0;  
            x[1] <= 16'sd0;  
            x[2] <= 16'sd0;  
            x[3] <= 16'sd0;  
            x[4] <= 16'sd0;  
            y[0] <= 16'sd0;  
            y[1] <= 16'sd0;  
            y[2] <= 16'sd0;  
            y[3] <= 16'sd0;  
            y[4] <= 16'sd0;  
        end else begin  
            x[0] <= x_in;  
            y_out <= b0*x[0] + b1*x[1] + b2*x[2] + b3*x[3] + b4*x[4] - a1*y[1] - a2*y[2] - a3*y[3] - a4*y[4];  
            x[1] <= x[0];  
            x[2] <= x[1];  
            x[3] <= x[2];  
            x[4] <= x[3];  
            y[1] <= y[0];  
            y[2] <= y[1];  
            y[3] <= y[2];  
            y[4] <= y[3];  
            y[0] <= y_out;  
        end  
    end  
endmodule