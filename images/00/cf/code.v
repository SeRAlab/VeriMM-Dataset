module SRAM_8bit (  
    input wire [7:0] data_in,  
    input wire [2:0] address,  
    input wire write_enable,  
    input wire read_enable,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:7];  // 8x8-bit SRAM  
  
    always @(posedge write_enable) begin  
        if (write_enable) begin  
            memory[address] <= data_in;  
        end  
    end  
  
    always @(posedge read_enable) begin  
        if (read_enable) begin  
            data_out <= memory[address];  
        end  
    end  
endmodule