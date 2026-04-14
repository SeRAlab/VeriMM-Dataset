module pitch_detector (  
    input clk,  
    input [7:0] freq_input,  
    output reg valid_freq  
);  
    // Frequency range constants  
    parameter MIN_FREQ = 8'd50;  
    parameter MAX_FREQ = 8'd200;  

    always @(posedge clk) begin  
        if (freq_input >= MIN_FREQ && freq_input <= MAX_FREQ)  
            valid_freq <= 1;  
        else  
            valid_freq <= 0;  
    end  
endmodule