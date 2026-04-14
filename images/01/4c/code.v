module ofdm_modulator (  
    input wire [3:0] data_in,  
    input wire enable,  
    output reg [3:0] data_out,  
    input wire clk,  
    input wire reset  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 4'b0000;  
        end else if (enable) begin  
            data_out <= data_in;  
        end  
    end  
endmodule