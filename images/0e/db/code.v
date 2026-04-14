module SRAM_4bit (  
    input [3:0] data_in,  
    input write_enable,  
    input read_enable,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge write_enable) begin  
        memory <= data_in;  
    end  

    always @(posedge read_enable) begin  
        data_out <= memory;  
    end  
endmodule