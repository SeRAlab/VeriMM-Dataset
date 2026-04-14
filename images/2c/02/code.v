module dram_cell(  
    input wire clk,  
    input wire we,          // Write enable  
    input wire re,          // Read enable  
    input wire [15:0] din,  // Data input  
    output reg [15:0] dout  // Data output  
);  
    // Internal register to store the data  
    reg [15:0] memory;  
    
    always @(posedge clk) begin  
        if (we) begin  
            memory <= din;  // Write data to memory on rising edge of clk  
        end  
    end  
    
    always @(posedge clk) begin  
        if (re) begin  
            dout <= memory;  // Read data from memory on rising edge of clk  
        end  
    end  
endmodule