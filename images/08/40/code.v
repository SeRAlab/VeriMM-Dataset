module dram_cell (  
    input clk,  
    input we,  
    input [2:0] addr,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:7]; // 8 x 8-bit memory cells  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write data to the specified address  
        end  
        data_out <= memory[addr]; // Read data from the specified address  
    end  
endmodule