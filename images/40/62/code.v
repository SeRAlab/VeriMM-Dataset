module dram_cell_4bit (  
    input wire clk,  
    input wire write_enable,  
    input wire [1:0] address,  
    input wire [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory [0:3];  
    always @(posedge clk) begin  
        if (write_enable) begin  
            memory[address] <= data_in;  
        end  
        data_out <= memory[address];  
    end  
endmodule