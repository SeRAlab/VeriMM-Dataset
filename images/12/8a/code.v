module ofdm_modulator(  
    input [3:0] symbol,  
    output reg [15:0] modulated_signal  
);  
    always @(symbol) begin  
        modulated_signal = {symbol, symbol, symbol, symbol};  
    end  
endmodule