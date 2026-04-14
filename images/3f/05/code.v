module SRAM_Cell (  
    input wire clk,  
    input wire enable,  
    input wire [3:0] data_in,  
    input wire read,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge clk) begin  
        if (enable) begin  
            memory <= data_in;  
        end  
    end  

    always @(posedge clk) begin  
        if (read) begin  
            data_out <= memory;  
        end  
    end  
endmodule