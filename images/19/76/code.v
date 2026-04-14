module SRAM_Cell (  
    input clk,  
    input [7:0] data_in,  
    input write_enable,  
    input read_enable,  
    input chip_enable,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  
  
    always @(posedge clk) begin  
        if (chip_enable) begin  
            if (write_enable) begin  
                memory <= data_in;  
            end  
            if (read_enable) begin  
                data_out <= memory;  
            end  
        end  
    end  
endmodule