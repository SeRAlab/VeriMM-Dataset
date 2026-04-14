module dram_cell (  
    input [3:0] data_in,  
    input we,  
    input re,  
    input clk,  
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