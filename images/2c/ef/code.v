module SRAM_8bit (
    input wire [7:0] data_in,
    input wire we, // write enable
    input wire re, // read enable
    input wire [2:0] address, // 3-bit address for 8 locations
    input wire clk,
    output reg [7:0] data_out
);

    reg [7:0] memory [0:7]; // 8 locations of 8 bits each

    always @(posedge clk) begin
        if (we) begin
            memory[address] <= data_in; // Write data to memory
        end
        if (re) begin
            data_out <= memory[address]; // Read data from memory
        end
    end
endmodule