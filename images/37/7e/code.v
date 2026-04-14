module SRAM_16bit #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 16) (  
    input wire clk,  
    input wire we,  
    input wire [ADDR_WIDTH-1:0] addr,  
    input wire [DATA_WIDTH-1:0] data_in,  
    output reg [DATA_WIDTH-1:0] data_out  
);  
    reg [DATA_WIDTH-1:0] memory [0:15];  

    always @(posedge clk) begin  
        if (we)  
            memory[addr] <= data_in;  
        data_out <= memory[addr];  
    end  
endmodule