module ofdm_symbol_generator(  
    input clk,  
    input rst,  
    input [3:0] data_in,  
    output reg [5:0] ofdm_symbol_out  
);  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        ofdm_symbol_out <= 6'b000000;  
    end else begin  
        ofdm_symbol_out <= {data_in[1:0], data_in};  
    end  
end  
endmodule