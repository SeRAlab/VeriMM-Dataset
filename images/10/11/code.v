module IIR_Filter #(parameter COEFF_A0 = 1, COEFF_A1 = 2, COEFF_A2 = 3, COEFF_A3 = 4, COEFF_B0 = 1, COEFF_B1 = 1, COEFF_B2 = 1, COEFF_B3 = 1)(  
    input clk,  
    input reset,  
    input signed [15:0] x,  
    output reg signed [15:0] y  
);  
    reg signed [15:0] x_hist [0:3];  
    reg signed [15:0] y_hist [0:3];  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            y <= 0;  
            for (i = 0; i < 4; i = i + 1) begin  
                x_hist[i] <= 0;  
                y_hist[i] <= 0;  
            end  
        end else begin  
            // Shift history  
            for (i = 3; i > 0; i = i - 1) begin  
                x_hist[i] <= x_hist[i - 1];  
                y_hist[i] <= y_hist[i - 1];  
            end  
            x_hist[0] <= x;  
            // IIR filter calculation  
            y <= (COEFF_B0 * x_hist[0] + COEFF_B1 * x_hist[1] + COEFF_B2 * x_hist[2] + COEFF_B3 * x_hist[3] -  
                  COEFF_A1 * y_hist[1] - COEFF_A2 * y_hist[2] - COEFF_A3 * y_hist[3]) >> 2;  
            y_hist[0] <= y;  
        end  
    end  
endmodule