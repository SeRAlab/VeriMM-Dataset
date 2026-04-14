module SRAM_8bit (
    input wire clk,
    input wire [2:0] address, // 3-bit address for 8 possible locations
    input wire [7:0] data_in,  // 8-bit input data
    input wire write_enable,    // Signal to write data
    input wire read_enable,     // Signal to read data
    output reg [7:0] data_out   // 8-bit output data
);
    reg [7:0] memory [7:0]; // 8 locations of 8-bit memory

    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data to memory
        end
        if (read_enable) begin
            data_out <= memory[address]; // Read data from memory
        end
    end
endmodule