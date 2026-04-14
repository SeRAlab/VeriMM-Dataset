module dram_cell (  
    input wire clk,  
    input wire [3:0] addr,  
    input wire [15:0] data_in,  
    input wire we, // write enable  
    input wire re, // read enable  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:15]; // 16 x 16-bit memory array  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write data to memory  
        end  
        if (re) begin  
            data_out <= memory[addr]; // Read data from memory  
        end  
    end  
endmodule