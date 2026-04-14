module dram_cell(  
    input [1:0] addr,  
    input [3:0] data_in,  
    input wr_en,  
    input clk,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory [3:0]; // 4 cells of 4 bits each  
  
    always @(posedge clk) begin  
        if (wr_en) begin  
            memory[addr] <= data_in; // Write data to the selected address  
        end  
        data_out <= memory[addr]; // Read data from the selected address  
    end  
endmodule