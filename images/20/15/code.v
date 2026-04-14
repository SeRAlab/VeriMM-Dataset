module sram_cell(  
    input clk,  
    input [3:0] addr,  
    input [15:0] data_in,  
    input we,  
    input re,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:15];  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in;  
        end  
        if (re) begin  
            data_out <= memory[addr];  
        end  
    end  
endmodule