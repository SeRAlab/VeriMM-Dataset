module ofdm_modulator(  
    input clk,  
    input reset,  
    input [15:0] data_in,  
    output reg [15:0] ofdm_symbols  
);  
    reg [3:0] bit_counter;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_counter <= 0;  
            ofdm_symbols <= 0;  
        end else if (bit_counter < 4) begin  
            ofdm_symbols[bit_counter * 4 +: 4] <= data_in[bit_counter * 4 +: 4];  
            bit_counter <= bit_counter + 1;  
        end  
    end  
endmodule