module SRAM_16bit (  
    input wire [3:0] addr,        // 4-bit address for 16 locations  
    input wire [15:0] data_in,    // 16-bit data input  
    output reg [15:0] data_out,    // 16-bit data output  
    input wire we,                 // Write enable  
    input wire re,                 // Read enable  
    input wire clk                 // Clock input  
);  
    reg [15:0] memory [0:15];      // 16 locations of 16-bit memory  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write operation  
        end  
        if (re) begin  
            data_out <= memory[addr]; // Read operation  
        end  
    end  
endmodule