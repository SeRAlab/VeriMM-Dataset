module SRAM_CELL(input wire clk,  
                  input wire we,  
                  input wire re,  
                  input wire [2:0] addr,  
                  input wire [7:0] data_in,  
                  output reg [7:0] data_out);  
                  
    reg [7:0] memory [0:7]; // 8x8-bit SRAM  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write data  
        end  
    end  

    always @(*) begin  
        if (re) begin  
            data_out = memory[addr]; // Read data  
        end else begin  
            data_out = 8'bz; // High impedance when not reading  
        end  
    end  
endmodule