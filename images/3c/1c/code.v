module ofdm_demodulator(  
    input [3:0] freq_symbol,  
    output [3:0] demodulated_symbol  
);  
    assign demodulated_symbol = ~freq_symbol; // Bit inversion for demonstration  
endmodule