module fir_filter (  
    input [15:0] x,  // 16-bit input  
    output reg [15:0] y  // 16-bit output  
);  
    reg [15:0] coeff [0:15];  // Coefficients for the FIR filter  
    reg [15:0] delay [0:15];  // Delay line  
    integer i;  
  
    initial begin  
        // Initialize coefficients (example values)  
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
  
    always @(*) begin  
        // Shift the input through the delay line  
        for (i = 15; i > 0; i = i - 1) begin  
            delay[i] = delay[i - 1];  
        end  
        delay[0] = x;  // New input  
        
        // Calculate the output  
        y = 16'h0000;  
        for (i = 0; i < 16; i = i + 1) begin  
            y = y + (delay[i] * coeff[i]);  
        end  
    end  
endmodule