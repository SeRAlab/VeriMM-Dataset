module dram_cell #(parameter ADDR_WIDTH = 8, DATA_WIDTH = 16) (  
    input wire clk,  
    input wire [ADDR_WIDTH-1:0] addr,  
    input wire [DATA_WIDTH-1:0] data_in,  
    input wire write_enable,  
    input wire read_enable,  
    output reg [DATA_WIDTH-1:0] data_out  
);  
    reg [DATA_WIDTH-1:0] memory [(2**ADDR_WIDTH)-1:0];  

    always @(posedge clk) begin  
        if (write_enable) begin  
            memory[addr] <= data_in;  
        end  
        if (read_enable) begin  
            data_out <= memory[addr];  
        end  
    end  
endmodule