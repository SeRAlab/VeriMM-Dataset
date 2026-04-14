module ofdm_modulator (  
    input wire clk,  
    input wire [3:0] symbol,  
    output reg [15:0] o_output  
);  
    always @(posedge clk) begin  
        o_output <= {symbol, symbol, symbol, symbol};  
    end  
endmodule