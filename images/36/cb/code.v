module SRAM_4bit (  
    input wire [3:0] data_in,  
    input wire write_enable,  
    output reg [3:0] data_out  
);  
    always @(posedge write_enable) begin  
        data_out <= data_in;  
    end  
endmodule