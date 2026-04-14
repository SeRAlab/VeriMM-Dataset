module iir_filter (  
    input wire clk,  
    input wire reset,  
    input wire signed [15:0] x_in,  
    output reg signed [15:0] y_out  
);  
    // Filter coefficients  
    parameter signed [15:0] b0 = 16'sd1;  
    parameter signed [15:0] b1 = 16'sd1;  
    parameter signed [15:0] b2 = 16'sd1;  
    parameter signed [15:0] a1 = 16'sd1;  
    parameter signed [15:0] a2 = 16'sd1;  

    // Internal states  
    reg signed [15:0] x1, x2;  
    reg signed [15:0] y1, y2;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x1 <= 16'sd0;  
            x2 <= 16'sd0;  
            y1 <= 16'sd0;  
            y2 <= 16'sd0;  
            y_out <= 16'sd0;  
        end else begin  
            // IIR filter equation  
            y_out <= (b0 * x_in + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >>> 15;  
            // Update states  
            x2 <= x1;  
            x1 <= x_in;  
            y2 <= y1;  
            y1 <= y_out;  
        end  
    end  
endmodule