module iir_filter(  
    input clk,  
    input reset,  
    input [15:0] x,  
    output reg [15:0] y  
);  
    reg [15:0] b[0:4]; // numerator coefficients  
    reg [15:0] a[0:4]; // denominator coefficients  
    reg [15:0] x_reg[0:3]; // input samples  
    reg [15:0] y_reg[0:3]; // output samples  

    integer i;  

    initial begin  
        // Example coefficients for the IIR filter  
        b[0] = 16'h0001;  
        b[1] = 16'h0002;  
        b[2] = 16'h0003;  
        b[3] = 16'h0000;  
        b[4] = 16'h0000;  
        a[0] = 16'h0001;  
        a[1] = 16'h0001;  
        a[2] = 16'h0000;  
        a[3] = 16'h0000;  
        a[4] = 16'h0000;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            y <= 16'h0000;  
            for (i = 0; i < 4; i = i + 1) begin  
                x_reg[i] <= 16'h0000;  
                y_reg[i] <= 16'h0000;  
            end  
        end else begin  
            // Shift registers for input samples  
            for (i = 3; i > 0; i = i - 1) begin  
                x_reg[i] <= x_reg[i-1];  
                y_reg[i] <= y_reg[i-1];  
            end  
            x_reg[0] <= x;  

            // Calculate output  
            y <= (b[0]*x_reg[0] + b[1]*x_reg[1] + b[2]*x_reg[2] + b[3]*x_reg[3] + b[4]*x_reg[4]) >> 2;  
            y <= y - (a[1]*y_reg[1] + a[2]*y_reg[2] + a[3]*y_reg[3] + a[4]*y_reg[4]) >> 2;  

            // Shift output register  
            y_reg[0] <= y;  
        end  
    end  
endmodule