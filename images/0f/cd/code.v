module ofdm_modulator (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] symbol_in,  
    output reg [7:0] symbol_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            symbol_out <= 8'b0;  
        end else begin  
            symbol_out <= {symbol_in, symbol_in};  
        end  
    end  
endmodule