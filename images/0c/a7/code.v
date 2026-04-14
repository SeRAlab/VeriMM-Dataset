module dram_cell(  
    input clk,  
    input write_en,  
    input read_en,  
    input [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  
    
    always @(posedge clk) begin  
        if (write_en) begin  
            memory <= data_in;  
        end  
        if (read_en) begin  
            data_out <= memory;  
        end  
    end  
endmodule