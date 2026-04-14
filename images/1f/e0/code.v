module fir_filter(  
    input [7:0] x,  
    output reg [15:0] y  
);  
    // Fixed coefficients for the FIR filter  
    reg [7:0] coeff[0:7];  
    reg [15:0] sum;  
    integer i;  
  
    initial begin  
        // Initialize coefficients  
        coeff[0] = 8'h1;  
        coeff[1] = 8'h2;  
        coeff[2] = 8'h3;  
        coeff[3] = 8'h4;  
        coeff[4] = 8'h5;  
        coeff[5] = 8'h6;  
        coeff[6] = 8'h7;  
        coeff[7] = 8'h8;  
    end  
  
    always @(*) begin  
        sum = 16'h0;  
        // Calculate the output using the FIR formula  
        for(i = 0; i < 8; i = i + 1) begin  
            sum = sum + (x * coeff[i]);  
        end  
        y = sum;  
    end  
endmodule