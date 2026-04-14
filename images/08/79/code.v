module dram_cell(  
    input wire clk,  
    input wire [7:0] data_in,  
    input wire read_en,  
    input wire write_en,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  
    always @(posedge clk) begin  
        if (write_en) begin  
            memory <= data_in;  
        end  
    end  

    always @(posedge clk) begin  
        if (read_en) begin  
            data_out <= memory;  
        end  
    end  
endmodule