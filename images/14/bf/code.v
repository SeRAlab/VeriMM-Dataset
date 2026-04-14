module sram_cell (  
    input wire [3:0] address,  
    input wire [15:0] data_in,  
    input wire write_enable,  
    input wire clk,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [15:0]; // 16x16 SRAM memory  
  
    always @(posedge clk) begin  
        if (write_enable) begin  
            memory[address] <= data_in;  
        end  
        data_out <= memory[address];  
    end  
endmodule