module dram_cell (  
    input clk,  
    input rst,  
    input we,  
    input re,  
    input [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            memory <= 4'b0000;  
        else if (we)  
            memory <= data_in;  
    end  

    always @(posedge clk) begin  
        if (re)  
            data_out <= memory;  
    end  
endmodule