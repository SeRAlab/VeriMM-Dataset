module sram_cell (  
    input wire clk,  
    input wire we, // write enable  
    input wire re, // read enable  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  

    always @(posedge clk) begin  
        if (we) begin  
            memory <= data_in; // write data to SRAM  
        end  
    end  

    always @(posedge clk) begin  
        if (re) begin  
            data_out <= memory; // read data from SRAM  
        end  
    end  
endmodule