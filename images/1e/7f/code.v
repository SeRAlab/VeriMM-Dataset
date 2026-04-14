module sram_16bit (  
    input clk,  
    input [3:0] addr,  
    input [15:0] data_in,  
    input we,  // write enable  
    input re,  // read enable  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:15];  // 16 x 16-bit SRAM  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in;  // Write data to address  
        end  
        if (re) begin  
            data_out <= memory[addr];  // Read data from address  
        end  
    end  
endmodule