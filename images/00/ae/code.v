module dram_cell (  
    input clk,  
    input we,  
    input re,  
    input [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  
    always @(posedge clk) begin  
        if (we) begin  
            memory <= data_in;  
        end  
        if (re) begin  
            data_out <= memory;  
        end  
    end  
endmodule