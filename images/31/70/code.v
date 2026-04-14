module sram_cell_8bit (  
    input wire clk,  
    input wire [2:0] addr,  
    input wire [7:0] data_in,  
    input wire we, // Write enable  
    input wire re, // Read enable  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:7]; // 8x8-bit memory  

    always @(posedge clk) begin  
        if (we)  
            memory[addr] <= data_in; // Write data to memory  
    end  

    always @(posedge clk) begin  
        if (re)  
            data_out <= memory[addr]; // Read data from memory  
    end  
endmodule