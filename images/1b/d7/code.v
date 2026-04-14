module flash_memory_cell(  
    input clk,  
    input wr_enable,  
    input erase_enable,  
    input [1:0] data_in,  
    output reg [1:0] read_out  
);  
    reg [1:0] memory_cell;  
    
    always @(posedge clk) begin  
        if (erase_enable) begin  
            memory_cell <= 2'b00;  
        end else if (wr_enable) begin  
            memory_cell <= data_in;  
        end  
        read_out <= memory_cell;  
    end  
endmodule