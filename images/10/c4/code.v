module dram_cell(  
    input wire clk,  
    input wire we,  
    input wire re,  
    input wire [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  
  
    always @(posedge clk) begin  
        if (we) begin  
            memory <= data_in;  
        end  
    end  
  
    always @(posedge clk) begin  
        if (re) begin  
            data_out <= memory;  
        end  
    end  
endmodule