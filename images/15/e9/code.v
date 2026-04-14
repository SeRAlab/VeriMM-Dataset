module fir_filter(  
    input wire [15:0] x, // 16-bit input sample  
    output reg [15:0] y // 16-bit output sample  
);  
    reg [15:0] coeff [0:15]; // Coefficients for the FIR filter  
    reg [31:0] acc; // Accumulator for the result  
    integer i;  
  
    initial begin  
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
        acc = 0;  
        for (i = 0; i < 16; i = i + 1) begin  
            acc = acc + (x * coeff[i]);  
        end  
        y = acc[15:0]; // Output is 16-bit  
    end  
endmodule