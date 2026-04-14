module ofdm_modulator(  
    input clk,  
    input [3:0] data_in,  
    output reg [3:0] symbol_out  
);  

always @(posedge clk) begin  
    symbol_out <= data_in;  
end  
endmodule