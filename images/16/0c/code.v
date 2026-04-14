module iir_filter (  
    input clk,  
    input rst,  
    input signed [15:0] x,  
    output reg signed [15:0] y  
);  
    // Coefficients for the IIR filter  
    parameter signed [15:0] b0 = 16'd1;  
    parameter signed [15:0] b1 = 16'd1;  
    parameter signed [15:0] b2 = 16'd1;  
    parameter signed [15:0] a1 = 16'd1;  
    parameter signed [15:0] a2 = 16'd1;  
   
    reg signed [15:0] x1, x2; // Previous input values  
    reg signed [15:0] y1, y2; // Previous output values  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x1 <= 0;  
            x2 <= 0;  
            y1 <= 0;  
            y2 <= 0;  
            y <= 0;  
        end else begin  
            // Update the output value based on the IIR filter equation  
            y <= (b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >>> 16;  
            // Update the state variables  
            x2 <= x1;  
            x1 <= x;  
            y2 <= y1;  
            y1 <= y;  
        end  
    end  
endmodule