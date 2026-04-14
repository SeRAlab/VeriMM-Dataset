module fir_filter (  
    input wire clk,  
    input wire rst,  
    input wire [15:0] input_signal,  
    output reg [31:0] output_signal  
);  
    reg [15:0] samples [0:31];  
    reg signed [15:0] coefficients [0:31];  
    integer i;  
      
    initial begin  
        // Example coefficients for testing purposes  
        coefficients[0] = 16'd1;  
        coefficients[1] = 16'd1;  
        coefficients[2] = 16'd1;  
        coefficients[3] = 16'd1;  
        coefficients[4] = 16'd1;  
        coefficients[5] = 16'd1;  
        coefficients[6] = 16'd1;  
        coefficients[7] = 16'd1;  
        coefficients[8] = 16'd1;  
        coefficients[9] = 16'd1;  
        coefficients[10] = 16'd1;  
        coefficients[11] = 16'd1;  
        coefficients[12] = 16'd1;  
        coefficients[13] = 16'd1;  
        coefficients[14] = 16'd1;  
        coefficients[15] = 16'd1;  
        coefficients[16] = 16'd1;  
        coefficients[17] = 16'd1;  
        coefficients[18] = 16'd1;  
        coefficients[19] = 16'd1;  
        coefficients[20] = 16'd1;  
        coefficients[21] = 16'd1;  
        coefficients[22] = 16'd1;  
        coefficients[23] = 16'd1;  
        coefficients[24] = 16'd1;  
        coefficients[25] = 16'd1;  
        coefficients[26] = 16'd1;  
        coefficients[27] = 16'd1;  
        coefficients[28] = 16'd1;  
        coefficients[29] = 16'd1;  
        coefficients[30] = 16'd1;  
        coefficients[31] = 16'd1;  
    end  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            for (i = 0; i < 32; i = i + 1) begin  
                samples[i] <= 16'd0;  
            end  
            output_signal <= 32'd0;  
        end else begin  
            // Shift samples  
            for (i = 31; i > 0; i = i - 1) begin  
                samples[i] <= samples[i - 1];  
            end  
            samples[0] <= input_signal;  
              
            // Calculate the output signal  
            output_signal <= 32'd0;  
            for (i = 0; i < 32; i = i + 1) begin  
                output_signal <= output_signal + (samples[i] * coefficients[i]);  
            end  
        end  
    end  
endmodule