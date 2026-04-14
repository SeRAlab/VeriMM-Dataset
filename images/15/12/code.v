module ofdm_demodulator(  
    input [3:0] received_signal,  
    output [3:0] demodulated_data  
);  
    assign demodulated_data = ~received_signal;  
endmodule