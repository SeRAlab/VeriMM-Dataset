module ofdm_modulator (  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    output reg [7:0] ofdm_symbol,  
    output reg valid  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            ofdm_symbol <= 8'b0;  
            valid <= 0;  
        end else begin  
            case (data_in)  
                4'b0000: ofdm_symbol <= 8'b00000000; // 0 phase for both subcarriers  
                4'b0001: ofdm_symbol <= 8'b00010000; // 0 phase for first, 180 phase for second  
                4'b0010: ofdm_symbol <= 8'b00100000; // 180 phase for first, 0 phase for second  
                4'b0011: ofdm_symbol <= 8'b00110000; // 180 phase for both subcarriers  
                4'b0100: ofdm_symbol <= 8'b01000000; // 0 phase for first, 90 phase for second  
                4'b0101: ofdm_symbol <= 8'b01010000; // 0 phase for first, 270 phase for second  
                4'b0110: ofdm_symbol <= 8'b01100000; // 90 phase for first, 0 phase for second  
                4'b0111: ofdm_symbol <= 8'b01110000; // 90 phase for both  
                // Add more cases as necessary for other inputs  
                default: ofdm_symbol <= 8'b00000000;  
            endcase  
            valid <= 1;  
        end  
    end  
endmodule