module iir_filter #(parameter a1 = 1, a2 = 1, b0 = 1, b1 = 1, b2 = 1) (  
    input clk,  
    input rst,  
    input [15:0] x_in,  
    output reg [15:0] y_out  
);  
    reg [15:0] x [2:0];  
    reg [15:0] y [2:0];  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y_out <= 16'b0;  
            x[0] <= 16'b0;  
            x[1] <= 16'b0;  
            x[2] <= 16'b0;  
            y[0] <= 16'b0;  
            y[1] <= 16'b0;  
            y[2] <= 16'b0;  
        end else begin  
            x[2] <= x[1];  
            x[1] <= x[0];  
            x[0] <= x_in;  
            y[2] <= y[1];  
            y[1] <= y[0];  
            y[0] <= (b0*x[0] + b1*x[1] + b2*x[2] - a1*y[1] - a2*y[2]) >> 15;  
            y_out <= y[0];  
        end  
    end  
endmodule