module dram_cell #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 16) (  
    input wire clk,  
    input wire we, // Write enable  
    input wire [ADDR_WIDTH-1:0] addr,  
    input wire [DATA_WIDTH-1:0] data_in,  
    output reg [DATA_WIDTH-1:0] data_out  
);  
    reg [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1]; // 16-bit memory with 16 addresses  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write data to memory  
        end  
        data_out <= memory[addr]; // Read data from memory  
    end  
endmodule