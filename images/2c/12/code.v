module noise_suppression(  
    input [4:0] signal_in,  
    output reg clean_signal  
);  
    always @* begin  
        if (signal_in[0] + signal_in[1] + signal_in[2] + signal_in[3] + signal_in[4] > 2)  
            clean_signal = 1;  
        else  
            clean_signal = 0;  
    end  
endmodule