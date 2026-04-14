module iir_filter(clk, reset, x, y);  
    input clk;  
    input reset;  
    input signed [15:0] x;  
    output reg signed [15:0] y;  

    // Coefficients (for example purposes)
    parameter signed [15:0] b0 = 16'h1A2B;  
    parameter signed [15:0] b1 = 16'h1C2D;  
    parameter signed [15:0] b2 = 16'h1E2F;  
    parameter signed [15:0] b3 = 16'h2021;  
    parameter signed [15:0] b4 = 16'h2223;  
    parameter signed [15:0] a1 = 16'h1A2B;  
    parameter signed [15:0] a2 = 16'h1C2D;  
    parameter signed [15:0] a3 = 16'h1E2F;  
    parameter signed [15:0] a4 = 16'h2021;  

    reg signed [15:0] x_reg [0:4];  
    reg signed [15:0] y_reg [0:4];  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            y <= 16'b0;  
            // Reset state registers  
            x_reg[0] <= 16'b0;  
            x_reg[1] <= 16'b0;  
            x_reg[2] <= 16'b0;  
            x_reg[3] <= 16'b0;  
            x_reg[4] <= 16'b0;  
            y_reg[0] <= 16'b0;  
            y_reg[1] <= 16'b0;  
            y_reg[2] <= 16'b0;  
            y_reg[3] <= 16'b0;  
            y_reg[4] <= 16'b0;  
        end else begin  
            // Shift registers  
            x_reg[4] <= x_reg[3];  
            x_reg[3] <= x_reg[2];  
            x_reg[2] <= x_reg[1];  
            x_reg[1] <= x_reg[0];  
            x_reg[0] <= x;  

            y_reg[4] <= y_reg[3];  
            y_reg[3] <= y_reg[2];  
            y_reg[2] <= y_reg[1];  
            y_reg[1] <= y_reg[0];  

            // Compute output using IIR formula  
            y_reg[0] <= (b0 * x_reg[0] + b1 * x_reg[1] + b2 * x_reg[2] + b3 * x_reg[3] + b4 * x_reg[4]) -  
                         (a1 * y_reg[1] + a2 * y_reg[2] + a3 * y_reg[3] + a4 * y_reg[4]);  
            y <= y_reg[0];  
        end  
    end  
endmodule