module chebyshev_filter (  
    input clk,  
    input rst,  
    input [3:0] x_in,  
    output reg [3:0] y_out  
);  
    reg [3:0] x_prev1, x_prev2;  
    reg [3:0] y_prev1, y_prev2;  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x_prev1 <= 4'b0;  
            x_prev2 <= 4'b0;  
            y_prev1 <= 4'b0;  
            y_prev2 <= 4'b0;  
            y_out <= 4'b0;  
        end else begin  
            // 2nd order Chebyshev filter equation:  
            // y[n] = (b0*x[n] + b1*x[n-1] + b2*x[n-2] - a1*y[n-1] - a2*y[n-2])  
            // Coefficients for simplicity: b0 = 1, b1 = 0, b2 = 0, a1 = 1, a2 = 1  
            y_out <= x_in - y_prev1 - y_prev2;  
            x_prev2 <= x_prev1;  
            x_prev1 <= x_in;  
            y_prev2 <= y_prev1;  
            y_prev1 <= y_out;  
        end  
    end  
endmodule