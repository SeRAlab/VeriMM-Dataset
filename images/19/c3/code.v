module fir_filter (  
    input [7:0] x,  
    output reg [7:0] y  
);  
    // Coefficients for the 8-tap FIR filter  
    reg [7:0] coeff [0:7];  
    reg [7:0] shift_reg [0:7];  
  
    integer i;  
  
    initial begin  
        coeff[0] = 8'h01;  
        coeff[1] = 8'h02;  
        coeff[2] = 8'h03;  
        coeff[3] = 8'h04;  
        coeff[4] = 8'h05;  
        coeff[5] = 8'h06;  
        coeff[6] = 8'h07;  
        coeff[7] = 8'h08;  
        for (i = 0; i < 8; i = i + 1)  
            shift_reg[i] = 8'h00;  
    end  
  
    always @* begin  
        // Shift the input through the shift register  
        shift_reg[0] = x;  
        for (i = 1; i < 8; i = i + 1)  
            shift_reg[i] = shift_reg[i-1];  
  
        // Perform the filtering operation  
        y = 8'h00;  
        for (i = 0; i < 8; i = i + 1)  
            y = y + (shift_reg[i] * coeff[i]);  
    end  
endmodule