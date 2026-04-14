module ofdm_modulator (  
    input wire clk,  
    input wire reset,  
    input wire [3:0] data_in,  
    output reg [7:0] modulated_out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            modulated_out <= 8'b0;  
        end else begin  
            modulated_out <= {data_in, 4'b0};  
        end  
    end  
endmodule