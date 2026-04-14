module fir_filter (  
    input wire clk,  
    input wire [15:0] x,  
    output reg [15:0] y  
);  
    reg signed [15:0] coeff [0:31];  
    reg signed [15:0] delay_line [0:31];  
    integer i;  

    initial begin  
        // Example coefficients (truncated for brevity)  
        coeff[0] = 16'h0001;  
        coeff[1] = 16'h0002;  
        coeff[2] = 16'h0003;  
        // ... fill in all 32 coefficients  
        coeff[31] = 16'h0020;  
    end  

    always @(posedge clk) begin  
        // Shift the delay line  
        for (i = 31; i > 0; i = i - 1) begin  
            delay_line[i] <= delay_line[i - 1];  
        end  
        delay_line[0] <= x;  

        // Calculate the output  
        y <= 0;  
        for (i = 0; i < 32; i = i + 1) begin  
            y <= y + (delay_line[i] * coeff[i]);  
        end  
    end  
endmodule