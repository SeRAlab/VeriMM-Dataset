module fir_filter (  
    input clk,  
    input [15:0] x_in,  
    output reg [15:0] y_out  
);  
    reg [15:0] coeff [0:31];  
    reg [15:0] x [0:31];  
    integer i;  

    initial begin  
        // Sample coefficients (for example purposes)  
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
        coeff[16] = 16'h0011;  
        coeff[17] = 16'h0012;  
        coeff[18] = 16'h0013;  
        coeff[19] = 16'h0014;  
        coeff[20] = 16'h0015;  
        coeff[21] = 16'h0016;  
        coeff[22] = 16'h0017;  
        coeff[23] = 16'h0018;  
        coeff[24] = 16'h0019;  
        coeff[25] = 16'h001A;  
        coeff[26] = 16'h001B;  
        coeff[27] = 16'h001C;  
        coeff[28] = 16'h001D;  
        coeff[29] = 16'h001E;  
        coeff[30] = 16'h001F;  
        coeff[31] = 16'h0020;  
    end  

    always @(posedge clk) begin  
        // Shift the samples  
        for (i = 31; i > 0; i = i - 1) begin  
            x[i] <= x[i-1];  
        end  
        x[0] <= x_in;  

        // Compute the output  
        y_out <= 0;  
        for (i = 0; i < 32; i = i + 1) begin  
            y_out <= y_out + (x[i] * coeff[i]);  
        end  
    end  
endmodule