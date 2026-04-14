module fir_filter (  
    input wire [15:0] x,  // 16-bit input signal  
    output reg [15:0] y   // 16-bit output signal  
);  
    // Define the coefficients for the 16-tap FIR filter  
    reg [15:0] coeff [0:15];  
    integer i;  

    initial begin  
        // Example coefficients (fill these with desired values)  
        coeff[0] = 16'h1;  
        coeff[1] = 16'h2;  
        coeff[2] = 16'h3;  
        coeff[3] = 16'h4;  
        coeff[4] = 16'h5;  
        coeff[5] = 16'h6;  
        coeff[6] = 16'h7;  
        coeff[7] = 16'h8;  
        coeff[8] = 16'h9;  
        coeff[9] = 16'hA;  
        coeff[10] = 16'hB;  
        coeff[11] = 16'hC;  
        coeff[12] = 16'hD;  
        coeff[13] = 16'hE;  
        coeff[14] = 16'hF;  
        coeff[15] = 16'h10;  
    end  

    always @(*) begin  
        y = 16'h0;  
        for (i = 0; i < 16; i = i + 1) begin  
            y = y + (x * coeff[i]);  
        end  
    end  
endmodule