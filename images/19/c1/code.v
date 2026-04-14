module sram_cell(  
    input clk,  
    input we,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  

    always @(posedge clk) begin  
        if (we) begin  
            memory <= data_in;  
        end  
        data_out <= memory;  
    end  
endmodule