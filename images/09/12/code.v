module sram_cell (  
    input [7:0] data_in,  
    input write_enable,  
    input [2:0] address,  
    input clk,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [7:0]; // 8-addressable 8-bit memory  

    always @(posedge clk) begin  
        if (write_enable) begin  
            memory[address] <= data_in;  
        end  
        else begin  
            data_out <= memory[address];  
        end  
    end  
endmodule