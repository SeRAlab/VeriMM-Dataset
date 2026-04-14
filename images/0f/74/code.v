module fir_filter (  
    input [15:0] x,  
    input clk,  
    output reg [15:0] y  
);  
    // Coefficients for the 16-tap FIR filter  
    reg [15:0] coeff [0:15];  
    reg [15:0] shift_reg [0:15];  
    integer i;  
  
    initial begin  
        // Initialize coefficients  
        coeff[0] = 16'h0001;  
        coeff[1] = 16'h0002;  
        coeff[2] = 16'h0003;  
        coeff[3] = 16'h0004;  
        coeff[4] = 16'h0005;  
        coeff[5] = 16'h0006;  
        coeff[6] = 16'h0007;  
        coeff[7] = 16'h0008;  
        coeff[8] = 16'h0009;  
        coeff[9] = 16'h000A;  
        coeff[10] = 16'h000B;  
        coeff[11] = 16'h000C;  
        coeff[12] = 16'h000D;  
        coeff[13] = 16'h000E;  
        coeff[14] = 16'h000F;  
        coeff[15] = 16'h0010;  
    end  
  
    always @(posedge clk) begin  
        // Shift the input samples  
        for (i = 15; i > 0; i = i - 1) begin  
            shift_reg[i] <= shift_reg[i - 1];  
        end  
        shift_reg[0] <= x;  
  
        // Compute the output using the filter coefficients  
        y <= 0;  
        for (i = 0; i < 16; i = i + 1) begin  
            y <= y + (shift_reg[i] * coeff[i]);  
        end  
    end  
endmodule