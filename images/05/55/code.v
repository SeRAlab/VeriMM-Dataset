module dram_cell (  
    input clk,  
    input we,  
    input [2:0] addr,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg ready  
);  
    reg [7:0] memory [0:7]; // 8-bit DRAM with 8 addresses  
  
    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in;  
            ready <= 1;  
        end else begin  
            data_out <= memory[addr];  
            ready <= 1;  
        end  
    end  
endmodule