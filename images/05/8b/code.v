module SRAM_8bit (  
    input wire [7:0] data_in,  
    input wire [2:0] address,  
    input wire write_enable,  
    input wire clk,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:7]; // 8-bit SRAM with 8 addresses  

    always @(posedge clk) begin  
        if (write_enable) begin  
            memory[address] <= data_in; // Write data to the specified address  
        end  
        data_out <= memory[address]; // Always read the data from the specified address  
    end  
endmodule