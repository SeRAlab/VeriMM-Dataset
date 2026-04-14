module ofdm_modulator (  
    input clk,  
    input rst,  
    input [3:0] data_in,  
    output reg [7:0] modulated_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            modulated_out <= 8'b0;  
        end else begin  
            modulated_out <= {data_in[3], data_in[3], data_in[2], data_in[2], data_in[1], data_in[1], data_in[0], data_in[0]};  
        end  
    end  
endmodule