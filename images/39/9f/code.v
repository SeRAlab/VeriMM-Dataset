module dram_cell(  
    input wire clk,  
    input wire write_en,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  

    always @(posedge clk) begin  
        if (write_en) begin  
            memory <= data_in;  
        end  
        data_out <= memory;  
    end  
endmodule