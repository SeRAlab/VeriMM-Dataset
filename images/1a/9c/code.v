module sram_cell (  
    input wire clk,  
    input wire we,  
    input wire re,  
    input wire [3:0] addr,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:15]; // 16x16-bit memory array  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write data to specified address  
        end  
        if (re) begin  
            data_out <= memory[addr]; // Read data from specified address  
        end  
    end  
endmodule