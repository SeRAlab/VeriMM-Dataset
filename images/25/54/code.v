module SRAM_4bit (
    input wire clk,
    input wire we,
    input wire [3:0] data_in,
    input wire [1:0] addr,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3]; // 4-bit SRAM with 4 addresses
    
    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to SRAM
        end
        else begin
            data_out <= memory[addr]; // Read data from SRAM
        end
    end
endmodule