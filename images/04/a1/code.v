module SRAM_4bit(  
    input wire [3:0] data_in,  
    input wire [1:0] address,  
    input wire write_enable,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory [0:3]; // 4-bit memory with 4 addresses  

    always @(posedge write_enable) begin  
        memory[address] <= data_in;  
    end  

    always @(*) begin  
        data_out = memory[address];  
    end  
endmodule