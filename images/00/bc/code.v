module SRAM_4bit(  
    input wire [3:0] data,  
    input wire we,  
    input wire re,  
    input wire clk,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge clk) begin  
        if (we) begin  
            memory <= data;  
        end  
    end  

    always @(posedge clk) begin  
        if (re) begin  
            data_out <= memory;  
        end  
    end  
endmodule