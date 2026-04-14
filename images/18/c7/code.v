module sram_4bit (  
    input wire [3:0] data_in,  
    input wire read_enable,  
    input wire write_enable,  
    input wire [1:0] address,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory [3:0]; // 4-bit data for 4 addresses  

    always @(posedge write_enable) begin  
        if (write_enable) begin  
            memory[address] <= data_in;  
        end  
    end  

    always @(posedge read_enable) begin  
        if (read_enable) begin  
            data_out <= memory[address];  
        end  
    end  
endmodule