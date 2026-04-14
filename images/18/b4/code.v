module fir_filter(  
    input [15:0] x,  // 16-bit input signal  
    output reg [15:0] y  // 16-bit output signal  
);  
    reg [15:0] coefficients [0:15];  
    integer i;  
    reg [31:0] accumulator;  
  
    initial begin  
        coefficients[0] = 16'h0001;  
        coefficients[1] = 16'h0002;  
        coefficients[2] = 16'h0003;  
        coefficients[3] = 16'h0004;  
        coefficients[4] = 16'h0005;  
        coefficients[5] = 16'h0006;  
        coefficients[6] = 16'h0007;  
        coefficients[7] = 16'h0008;  
        coefficients[8] = 16'h0009;  
        coefficients[9] = 16'h000A;  
        coefficients[10] = 16'h000B;  
        coefficients[11] = 16'h000C;  
        coefficients[12] = 16'h000D;  
        coefficients[13] = 16'h000E;  
        coefficients[14] = 16'h000F;  
        coefficients[15] = 16'h0010;  
    end  
  
    always @(*) begin  
        accumulator = 0;  
        for (i = 0; i < 16; i = i + 1) begin  
            accumulator = accumulator + (x * coefficients[i]);  
        end  
        y = accumulator[15:0];  
    end  
endmodule