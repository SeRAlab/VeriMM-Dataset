module echo_cancellation (  
    input clk,  
    input rst,  
    input [15:0] audio_in,  
    output reg [15:0] audio_out  
);  
    reg [15:0] filter_coeff [0:3]; // 4-tap filter coefficients  
    reg [15:0] delay_line [0:3]; // delay line for input signals  
    reg [15:0] error_signal;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            audio_out <= 16'b0;  
            for (i = 0; i < 4; i = i + 1) begin  
                filter_coeff[i] <= 16'b0;  
                delay_line[i] <= 16'b0;  
            end  
        end else begin  
            // Update delay line  
            delay_line[0] <= audio_in;  
            for (i = 1; i < 4; i = i + 1) begin  
                delay_line[i] <= delay_line[i-1];  
            end  

            // Calculate output using the filter coefficients  
            audio_out <= (filter_coeff[0] * delay_line[0]) +  
                          (filter_coeff[1] * delay_line[1]) +  
                          (filter_coeff[2] * delay_line[2]) +  
                          (filter_coeff[3] * delay_line[3]);  

            // Calculate error signal  
            error_signal <= audio_in - audio_out;  

            // Update filter coefficients based on error signal (simple LMS adaptation)  
            for (i = 0; i < 4; i = i + 1) begin  
                filter_coeff[i] <= filter_coeff[i] + (error_signal >> 2); // simple adaptation  
            end  
        end  
    end  
endmodule