module iir_filter (  
    input clk,  
    input rst,  
    input signed [15:0] x,  
    input signed [15:0] y,  
    output reg signed [15:0] z  
);  
    // Filter coefficients  
    parameter signed [15:0] b0 = 16'h1A2B;  
    parameter signed [15:0] b1 = 16'h1B2C;  
    parameter signed [15:0] b2 = 16'h1C2D;  
    parameter signed [15:0] b3 = 16'h1D2E;  
    parameter signed [15:0] b4 = 16'h1E2F;  
    parameter signed [15:0] a1 = 16'h2A1B;  
    parameter signed [15:0] a2 = 16'h2B1C;  
    parameter signed [15:0] a3 = 16'h2C1D;  
    parameter signed [15:0] a4 = 16'h2D1E;  
   
    reg signed [15:0] x_n [0:4];  
    reg signed [15:0] y_n [0:4];  
   
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            z <= 16'b0;  
            x_n[0] <= 16'b0;  
            x_n[1] <= 16'b0;  
            x_n[2] <= 16'b0;  
            x_n[3] <= 16'b0;  
            x_n[4] <= 16'b0;  
            y_n[0] <= 16'b0;  
            y_n[1] <= 16'b0;  
            y_n[2] <= 16'b0;  
            y_n[3] <= 16'b0;  
            y_n[4] <= 16'b0;  
        end else begin  
            // Shift old values  
            x_n[4] <= x_n[3];  
            x_n[3] <= x_n[2];  
            x_n[2] <= x_n[1];  
            x_n[1] <= x_n[0];  
            x_n[0] <= x;  
          
            y_n[4] <= y_n[3];  
            y_n[3] <= y_n[2];  
            y_n[2] <= y_n[1];  
            y_n[1] <= y_n[0];  
            y_n[0] <= z;  
          
            // IIR filter calculation  
            z <= (b0 * x_n[0] + b1 * x_n[1] + b2 * x_n[2] + b3 * x_n[3] + b4 * x_n[4] -  
                   a1 * y_n[1] - a2 * y_n[2] - a3 * y_n[3] - a4 * y_n[4]) >>> 15;  
        end  
    end  
endmodule