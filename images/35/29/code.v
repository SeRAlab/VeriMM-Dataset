module fir_filter(  
    input wire clk,  
    input wire [7:0] x,  
    output reg [15:0] y  
);  
    reg signed [7:0] coeff [0:7];  
    reg signed [7:0] samples [0:7];  
    integer i;  
  
    initial begin  
        coeff[0] = 8'h1;  
        coeff[1] = 8'h1;  
        coeff[2] = 8'h1;  
        coeff[3] = 8'h1;  
        coeff[4] = 8'h1;  
        coeff[5] = 8'h1;  
        coeff[6] = 8'h1;  
        coeff[7] = 8'h1;  
    end  
  
    always @(posedge clk) begin  
        // Shift samples  
        for (i = 7; i > 0; i = i - 1) begin  
            samples[i] <= samples[i - 1];  
        end  
        samples[0] <= x;  
  
        // Compute output  
        y <= 0;  
        for (i = 0; i < 8; i = i + 1) begin  
            y <= y + samples[i] * coeff[i];  
        end  
    end  
endmodule