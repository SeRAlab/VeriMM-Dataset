module sram_cell (  
    input wire [7:0] data_in,  
    input wire [2:0] address,  
    input wire read_enable,  
    input wire write_enable,  
    output reg [7:0] data_out  
);  

    reg [7:0] memory [0:7]; // 8-bit SRAM with 8 locations

    always @(posedge write_enable) begin  
        memory[address] <= data_in;  
    end  

    always @(posedge read_enable) begin  
        data_out <= memory[address];  
    end  
endmodule