module sram_cell (  
    input wire [15:0] data_in,  
    input wire write_enable,  
    input wire [3:0] address,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [15:0]; // 16 x 16-bit SRAM  

    always @(posedge write_enable) begin  
        memory[address] <= data_in;  
    end  

    always @(*) begin  
        data_out = memory[address];  
    end  
endmodule