module OFDM_Modulator (  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    output reg [3:0] data_out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        data_out <= 4'b0000;  
    else  
        data_out <= data_in;  
end  
endmodule