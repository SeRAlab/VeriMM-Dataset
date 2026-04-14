module sram_cell (  
    input wire clk,  
    input wire [2:0] addr,  
    input wire [7:0] data_in,  
    input wire we,  // Write Enable  
    input wire re,  // Read Enable  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:7];  // 8-bit memory for 8 addresses  
  
    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in;  // Write operation  
        end  
    end  
  
    always @(posedge clk) begin  
        if (re) begin  
            data_out <= memory[addr];  // Read operation  
        end  
    end  
endmodule