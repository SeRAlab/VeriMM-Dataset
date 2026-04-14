module sram_cell(  
    input wire write_enable,  
    input wire [3:0] address,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out,  
    output reg ready  
);  
    reg [15:0] memory [15:0]; // 16x16-bit memory  
    always @(posedge write_enable) begin  
        memory[address] <= data_in;  
        ready <= 1;  
    end  
  
    always @(negedge write_enable) begin  
        data_out <= memory[address];  
        ready <= 1;  
    end  
endmodule