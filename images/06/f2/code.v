module noise_suppression(  
    input [4:0] noisy_signal,  
    output reg [4:0] clean_signal  
);  
    always @(*) begin  
        if (noisy_signal[2:0] == 3'b000) begin  
            clean_signal = 5'b00000;  
        end else begin  
            clean_signal = (noisy_signal[2] + noisy_signal[1] + noisy_signal[0]) / 3;  
        end  
    end  
endmodule