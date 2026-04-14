module sram_cell(  
    input [15:0] address,  
    input [15:0] data_in,  
    input write_enable,  
    input read_enable,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:65535]; // 16-bit SRAM with 64K addresses  

    always @(posedge write_enable) begin  
        memory[address] <= data_in;  
    end  

    always @(posedge read_enable) begin  
        data_out <= memory[address];  
    end  
endmodule