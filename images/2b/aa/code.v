module ofdm_modulator (  
    input wire clk,  
    input wire reset,  
    input wire [3:0] data_in,  
    output reg [3:0] modulated_out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            modulated_out <= 4'b0000;  
        else  
            modulated_out <= data_in;  
    end  
endmodule