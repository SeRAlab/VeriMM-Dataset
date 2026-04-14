module SRAM_16bit (  
    input wire clk,  
    input wire we,  
    input wire re,  
    input wire [3:0] addr,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  

    reg [15:0] memory [15:0]; // 16 entries of 16-bit memory  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write data to the memory  
        end  
        if (re) begin  
            data_out <= memory[addr]; // Read data from the memory  
        end  
    end  
endmodule