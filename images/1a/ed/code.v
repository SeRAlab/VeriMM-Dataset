module fir_filter (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] x,  
    output reg [3:0] y  
);  
    // Coefficients for the FIR filter  
    reg [3:0] coeffs [0:3];  
    reg [3:0] x_reg [0:3];  
    integer i;  

    initial begin  
        coeffs[0] = 4'b0001; // Coefficient for x[n]  
        coeffs[1] = 4'b0010; // Coefficient for x[n-1]  
        coeffs[2] = 4'b0011; // Coefficient for x[n-2]  
        coeffs[3] = 4'b0100; // Coefficient for x[n-3]  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y <= 0;  
            for (i = 0; i < 4; i = i + 1)  
                x_reg[i] <= 0;  
        end else begin  
            // Shift the input samples  
            x_reg[3] <= x_reg[2];  
            x_reg[2] <= x_reg[1];  
            x_reg[1] <= x_reg[0];  
            x_reg[0] <= x;  
          
            // Calculate the output  
            y <= (x_reg[0] * coeffs[0]) +  
                  (x_reg[1] * coeffs[1]) +  
                  (x_reg[2] * coeffs[2]) +  
                  (x_reg[3] * coeffs[3]);  
        end  
    end  
endmodule