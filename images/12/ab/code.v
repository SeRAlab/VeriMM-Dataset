module dram_cell(  
    input wire [3:0] data_in,  
    input wire write_enable,  
    input wire read_enable,  
    input wire clk,  
    output reg [3:0] data_out  
);  

    reg [3:0] memory;  

    always @(posedge clk) begin  
        if (write_enable) begin  
            memory <= data_in;  
        end  
    end  

    always @(posedge clk) begin  
        if (read_enable) begin  
            data_out <= memory;  
        end  
    end  
endmodule