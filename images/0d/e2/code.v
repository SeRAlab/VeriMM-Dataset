module dram_cell (  
    input wire clk,  
    input wire we,  // write enable  
    input wire re,  // read enable  
    input wire [3:0] data_in,  
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