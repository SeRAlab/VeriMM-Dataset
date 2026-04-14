module SRAM_Cell (  
    input wire [15:0] data_in,  
    input wire [3:0] address,  
    input wire read_enable,  
    input wire write_enable,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:15]; // 16x16-bit memory array  

    always @(posedge write_enable) begin  
        memory[address] <= data_in;  
    end  

    always @(posedge read_enable) begin  
        data_out <= memory[address];  
    end  
endmodule