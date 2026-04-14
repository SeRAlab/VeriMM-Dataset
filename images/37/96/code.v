module sram_4bit (  
    input [3:0] data_in,  
    input we,  
    input clk,  
    input [1:0] addr,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory [3:0]; // 4 SRAM cells, each 4 bits wide  
  
    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write data to SRAM  
        end else begin  
            data_out <= memory[addr]; // Read data from SRAM  
        end  
    end  
endmodule