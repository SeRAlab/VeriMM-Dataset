module iir_filter (  
    input clk,  
    input reset,  
    input signed [15:0] x_in,  
    output reg signed [15:0] y_out  
);  
    // Coefficients for the IIR filter  
    parameter signed [15:0] b0 = 16'h0A00;  
    parameter signed [15:0] b1 = 16'h1C00;  
    parameter signed [15:0] b2 = 16'h0A00;  
    parameter signed [15:0] b3 = 16'h0200;  
    parameter signed [15:0] b4 = 16'h0100;  
    parameter signed [15:0] a1 = 16'hF000;  
    parameter signed [15:0] a2 = 16'hD000;  
    parameter signed [15:0] a3 = 16'h0A00;  
    parameter signed [15:0] a4 = 16'h0050;  

    reg signed [15:0] x [0:4];  
    reg signed [15:0] y [0:4];  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            y_out <= 0;  
            x[0] <= 0;  
            y[0] <= 0;  
            x[1] <= 0;  
            x[2] <= 0;  
            x[3] <= 0;  
            x[4] <= 0;  
            y[1] <= 0;  
            y[2] <= 0;  
            y[3] <= 0;  
            y[4] <= 0;  
        end else begin  
            // Shift old samples  
            x[4] <= x[3];  
            x[3] <= x[2];  
            x[2] <= x[1];  
            x[1] <= x[0];  
            x[0] <= x_in;  

            y[4] <= y[3];  
            y[3] <= y[2];  
            y[2] <= y[1];  
            y[1] <= y[0];  
            y[0] <= (b0 * x[0] + b1 * x[1] + b2 * x[2] + b3 * x[3] + b4 * x[4] - a1 * y[1] - a2 * y[2] - a3 * y[3] - a4 * y[4]) >>> 12;  
            y_out <= y[0];  
        end  
    end  
endmodule