module dram_cell(  
    input wire clk,  
    input wire reset,  
    input wire we,  
    input wire re,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            memory <= 16'b0;  
            data_out <= 16'b0;  
        end else if (we) begin  
            memory <= data_in;  
        end else if (re) begin  
            data_out <= memory;  
        end  
    end  
endmodule