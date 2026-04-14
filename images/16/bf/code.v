module SRAM_16bit(  
    input wire clk,  
    input wire write,  
    input wire [3:0] address,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:15]; // 16x16-bit memory  

    always @(posedge clk) begin  
        if (write) begin  
            memory[address] <= data_in; // Write to memory  
        end  
        data_out <= memory[address]; // Read from memory  
    end  
endmodule