module iir_filter (  
    input clk,  
    input rst,  
    input signed [15:0] x_in,  
    output reg signed [15:0] y_out  
);  
    // Coefficients (fixed-point representation)  
    parameter signed [15:0] a1 = 16'h2000; // 0.5 in Q15 format  
    parameter signed [15:0] a2 = 16'h1000; // 0.25 in Q15 format  
    parameter signed [15:0] b0 = 16'h4000; // 1.0 in Q15 format  
    parameter signed [15:0] b1 = 16'hB000; // -0.5 in Q15 format  
    parameter signed [15:0] b2 = 16'h1000; // 0.25 in Q15 format  
    
    reg signed [15:0] x_prev1, x_prev2;  
    reg signed [15:0] y_prev1, y_prev2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y_out <= 16'h0000;  
            x_prev1 <= 16'h0000;  
            x_prev2 <= 16'h0000;  
            y_prev1 <= 16'h0000;  
            y_prev2 <= 16'h0000;  
        end else begin  
            // IIR filter formula  
            y_out <= (b0 * x_in + b1 * x_prev1 + b2 * x_prev2 - a1 * y_prev1 - a2 * y_prev2) >>> 14;  
            // Update previous values  
            x_prev2 <= x_prev1;  
            x_prev1 <= x_in;  
            y_prev2 <= y_prev1;  
            y_prev1 <= y_out;  
        end  
    end  
endmodule