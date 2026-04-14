module iir_filter (  
    input clk,  
    input reset,  
    input signed [15:0] x_in,  
    output reg signed [15:0] y_out  
);  
    // Coefficients for the IIR filter  
    parameter signed [15:0] b0 = 16'h1;  
    parameter signed [15:0] b1 = 16'h1;  
    parameter signed [15:0] b2 = 16'h1;  
    parameter signed [15:0] a1 = 16'h1;  
    parameter signed [15:0] a2 = 16'h1;  

    reg signed [15:0] x1, x2;  
    reg signed [15:0] y1, y2;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x1 <= 16'h0;  
            x2 <= 16'h0;  
            y1 <= 16'h0;  
            y2 <= 16'h0;  
            y_out <= 16'h0;  
        end else begin  
            // Update the filter state  
            y_out <= (b0 * x_in + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >>> 15;  
            // Shift the old samples  
            x2 <= x1;  
            x1 <= x_in;  
            y2 <= y1;  
            y1 <= y_out;  
        end  
    end  
endmodule