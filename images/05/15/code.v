module dram_cell (  
    input [15:0] data_in,  
    input [3:0] addr,  
    input we,  
    input clk,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [15:0]; // 16 addresses of 16 bits each  
  
    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write data  
        end else begin  
            data_out <= memory[addr]; // Read data  
        end  
    end  
endmodule