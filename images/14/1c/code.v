module ofdm_modulator(  
    input clk,  
    input [3:0] symbol_in,  
    output reg [7:0] symbol_out  
);  
    always @(posedge clk) begin  
        symbol_out <= {symbol_in, symbol_in};  
    end  
endmodule