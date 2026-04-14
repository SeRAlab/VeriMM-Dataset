module SRAM_4bit(  
    input wire [3:0] data_in,  
    input wire write_enable,  
    input wire read_enable,  
    input wire reset,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge write_enable or posedge reset) begin  
        if (reset) begin  
            memory <= 4'b0000;  
        end else begin  
            memory <= data_in;  
        end  
    end  

    always @(posedge read_enable) begin  
        data_out <= memory;  
    end  
endmodule