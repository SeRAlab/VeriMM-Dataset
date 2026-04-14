module SRAM_16bit (  
    input wire clk,  
    input wire we,  // write enable  
    input wire [3:0] address,  // 4-bit address for 16 locations  
    input wire [15:0] data_in,  // 16-bit data input  
    output reg [15:0] data_out  // 16-bit data output  
);  
    reg [15:0] memory [0:15];  // 16 locations of 16-bit memory  

    always @(posedge clk) begin  
        if (we) begin  
            memory[address] <= data_in;  // Write data to memory  
        end  
        data_out <= memory[address];  // Read data from memory  
    end  
endmodule