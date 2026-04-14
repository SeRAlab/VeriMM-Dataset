module dram_cell (  
    input wire clk,  
    input wire wr_en,  
    input wire rd_en,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    input wire [2:0] addr  
);  
    reg [7:0] memory [0:7]; // 8-bit wide DRAM with 8 addressable cells  
    reg [7:0] stored_data;  
  
    always @(posedge clk) begin  
        if (wr_en) begin  
            memory[addr] <= data_in; // Write operation  
        end  
        if (rd_en) begin  
            stored_data <= memory[addr]; // Read operation  
        end  
    end  
  
    always @(posedge clk) begin  
        data_out <= stored_data;  
    end  
endmodule