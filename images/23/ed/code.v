module SRAM_4bit (  
    input wire [3:0] data_in,  
    input wire write_enable,  
    input wire read_enable,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge write_enable or posedge read_enable) begin  
        if (write_enable)  
            memory <= data_in;  
    end  

    always @(posedge read_enable) begin  
        data_out <= memory;  
    end  
endmodule