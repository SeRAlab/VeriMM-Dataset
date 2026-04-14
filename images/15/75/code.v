module SRAM_Cell #(parameter ADDR_WIDTH = 3, DATA_WIDTH = 8) (  
    input wire clk,  
    input wire [ADDR_WIDTH-1:0] addr,  
    input wire [DATA_WIDTH-1:0] data_in,  
    input wire we,  // Write Enable  
    output reg [DATA_WIDTH-1:0] data_out  
);  

    reg [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in;  
        end  
        data_out <= memory[addr];  
    end  
endmodule