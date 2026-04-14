module fir_filter (  
    input [15:0] x,  
    output reg [15:0] y  
);  
    reg [15:0] coeffs [0:15];  
    reg [15:0] samples [0:15];  
    integer i;  

    initial begin  
        coeffs[0] = 16'h0001;  
        coeffs[1] = 16'h0002;  
        coeffs[2] = 16'h0003;  
        coeffs[3] = 16'h0004;  
        coeffs[4] = 16'h0005;  
        coeffs[5] = 16'h0006;  
        coeffs[6] = 16'h0007;  
        coeffs[7] = 16'h0008;  
        coeffs[8] = 16'h0009;  
        coeffs[9] = 16'h000A;  
        coeffs[10] = 16'h000B;  
        coeffs[11] = 16'h000C;  
        coeffs[12] = 16'h000D;  
        coeffs[13] = 16'h000E;  
        coeffs[14] = 16'h000F;  
        coeffs[15] = 16'h0010;  
    end  

    always @(*) begin  
        y = 0;  
        for (i = 0; i < 16; i = i + 1) begin  
            samples[i] = (i == 0) ? x : samples[i-1];  
            y = y + (samples[i] * coeffs[i]);  
        end  
    end  
endmodule