module dram_cell(  
    input clk,  
    input [7:0] data_in,  
    input read_en,  
    input write_en,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  
    
    always @(posedge clk) begin  
        if (write_en)  
            memory <= data_in;  
        if (read_en)  
            data_out <= memory;  
    end  
endmodule