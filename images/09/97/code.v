module OFDM_Modulator(input [7:0] data_in,  
                      input clk,  
                      input rst,  
                      output reg [15:0] ofdm_symbol);  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ofdm_symbol <= 16'b0;  
        end else begin  
            if (data_in <= 8'hFF) begin  
                // Simplified IFFT operation (just replicate for this example)  
                ofdm_symbol <= {data_in, data_in};  
            end else begin  
                ofdm_symbol <= 16'b0; // Invalid input handling  
            end  
        end  
    end  
endmodule