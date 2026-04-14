module DRAM_cell(  
    input clk,  
    input write_enable,  
    input [3:0] address,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:15]; // 16x16 memory  
     
    always @(posedge clk) begin  
        if (write_enable) begin  
            memory[address] <= data_in;  
        end  
        data_out <= memory[address];  
    end  
endmodule